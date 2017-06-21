require 'email_checker'
require 'json_web_token'

class UsersController < ApplicationController
  #TODO vyřešit přístup k seznamu uživatelů bez přihlášení...asi v routes.rb
  skip_before_action :authorize

  def index
    #@users = User.all
  end

  def new
    if current_user
      redirect_to profile_path
    else
      @user = User.new
    end
  end

  def create
    @origin = eval(params[:origin])[:value] # hash > string origin controller action pro renderovani
                                            # spravne sablony (registrace, dokončení registrace, profil)
    @user = User.find_by(email: user_params[:email].downcase)
    if @user              # přesměrovat existujícího uživatele na login stránku
      flash[:warning] = "<strong>Zadanou emailovou adresu už známe.</strong><br>Zkusíš se přihlásit?<br>
                         Pokud neznáš heslo, klikni <a href=\"/password_recovery\"
                         class=\"opposite underline\">sem</a> a my ti pomůžeme získat nové."
      redirect_to '/login' and return
    else                  # pokud je email správně vyplněn, zobrazit na šabloně
                          # celý formulář pro registraci pomocí @form_page
      @user = User.new(user_params)
      EmailChecker.new(user_params[:email]).valid? ? @form_page = 2 : @form_page = 1
    end
    @user.role = User.roles["registered"]
    if @user.save
      GoogleAnalyticsApi.new.event('users', 'registered - user', '', params[:ga_user_id], location: request.url, user_type: "no_auth")
      session[:user_id] = @user.id
      redirect_to '/'
    else
      flash[:danger] = "Ooops, je asi potřeba ještě něco vyplnit ve formuláři."
      flash.discard
      render @origin
    end
  end

  def update
    #UPDATE se používá při
      # aktualizaci profilu
      # dokončení registrace guestem
      # změna hesla

    #FIXME update profilu nelze uložit bez zadání hesla
    @origin = eval(params[:origin])[:value] # hash > string origin controller action pro renderovani
                                            # spravne sablony (registrace, dokončení registrace, profil)

    #TODO security: find_by params[:id] znamená, že někdo postem může aktualizovat existujícího uživatele
    @user = User.find_by(id: params[:id])
    begin
      if params[:id] != session_user && !params[:t]
        MyLogger.logme("SECURITY", "updatované id != session_id a není nastaven token", session_user: session_user, old_user: @user, params: params, level: "warn")
      end
    rescue => e
      MyLogger.logme("SECURITY", "FAILED: updatované id != session_id a není nastaven token", error: e, level: "error")
    end

    if @user && @user.update_attributes(user_params)
      #TODO guest registrace: chci sbírat nějaká dodatečná data? pokud ano, měl bych guesta ponechat guesta i po
        # resetu hesla
      if @user.role == "guest"              # nastavení role "registered" pokud je guest
        @user.role = User.roles["registered"]
        GoogleAnalyticsApi.new.event('users', 'registered - guest', '', params[:ga_user_id], location: request.url, user_type: 'guest')
      end
      @user.save
      if !current_user          # nastavení hlášky po updatu hesla - probíhá v nepřihlášeném režimu
                                # tudíž zde implicitně zkouším jestli je current_user, pokud ne
                                # zobrazuju hlášku po update hesla
        flash[:success] = "Heslo jsme ti nastavili, můžeš se s ním teď přihlásit."
        flash.discard
        @email = @user.email
        render 'sessions/new' and return
      end
      redirect_to lists_path
    else
      render @origin
    end
  end

  def guest_registration
    @user = User.find_by(id: session_user)
    if @user && !@user.registered?
      @user.errors.add(:password, :blank, message: "Nastav si heslo.")
      @user.errors.add(:password_confirmation, :blank, message: "Potvrď heslo.")
    else
      redirect_to signup_path
    end
  end

  def profile
    @user = User.find_by(id: session_user)
    if @user && @user.registered?
      render 'profile'
    else
      redirect_to login_path
    end
  end

  def invite
    #TODO invitations: flash s tím kde může spravovat pozvánky
    #TODO invitations: ošetřit, že nemůže pozvat sám sebe
    #TODO invitations: přesunout pozvánky do List controlleru kvůli ukládání dat k seznamu

    @list = List.authentic?(params[:list_id], current_user.id)
    if !@list
      raise 'List not authentic'
      redirect to '/' and return
    else
      @list.invitation_text = params[:invitation_text]
      @list.save
    end
    emails = EmailChecker.new(params[:emails].downcase)

    @new_invitees = []
    @valid = emails.valid
    @valid.each do |e|
      @user = User.find_or_create_by(email: e) do |u|
        u.role = 0
        u.password = "empty"
        u.password_digest = "empty"
        GoogleAnalyticsApi.new.event('users', "guest invited", @list.occasion, params[:ga_user_id], location: request.url, user_type: 'registered', list_type: @list.occasion)
      end
      UserMailer.delay(strategy: :delete_previous_duplicate).invitation_email(list: @list, user: @user)
      @new_invitees << @user if !@list.invitees.include?(@user)
      @list.invitees << @user if !@list.invitees.include?(@user)
    end
    @invalid = emails.invalid.join(", ")
    @list = @list.decorate
  end

  def uninvite
    @list = List.authentic?(params[:list_id], current_user.id)
    @list.invitees.count
    if !@list
      raise "List not authentic"
      redirect_to '/' and return
    end
    #TODO ošetřit že na to někdo klikne dvakrát a už nebude co mazat
    InvitationList.find_by(user_id: params[:user_id], list_id: @list.id).destroy
    @invitee_id = params[:user_id]
  end

  def password_recovery       # form na vyžádání resetu hesla
  end

  def recover_password        # akce pro zaslání emailu
    @email = params[:email].downcase
    if EmailChecker.new(@email).valid?
      User.recover_password(@email)
      flash[:warning] = "Pokud tvojí adresu známe, poslali jsme ti na ní
                         email s instrukcemi k resetu hesla."
      flash.discard
      render 'password_recovery'
    else
      flash[:danger] = "Takhle emailová adresa nevypadá. Zkusíš to ještě jednou?"
      flash.discard
      render 'password_recovery'
    end
  end

  def reset_password          # form na zadání nového hesla přístupný přes odkaz v emailu
                              # submit formuláře zpracuje users#update
    redirect_to '/password_recovery' and return unless params[:t]
    @user = User.find_by_token(params[:t], event: "reset_password")
    unless @user
      flash[:danger] = "Platnost odkazu na obnovení hesla vypršela, nech si poslat nový."
      flash.discard
      render 'password_recovery' and return
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :surname, :password, :password_confirmation, :t)
  end
end
