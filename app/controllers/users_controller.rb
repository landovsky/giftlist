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
    @user = User.find_by(email: user_params[:email])
    if @user              # přesměrovat existujícího uživatele na login stránku
      #TODO BEFORE PRODUCTION dodělat hlášku pro guesta na login stránce
      flash[:warning] = "<strong>Zadanou emailovou adresu už známe.</strong><br>Zkusíš se přihlásit? Pokud nemáš heslo, klikni na \"zapomněl jsem heslo\" a my ti pošleme nové."
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
      render @origin
    end
  end

  def update
    #FIXME update profilu nelze uložit bez zadání hesla
    @origin = eval(params[:origin])[:value] # hash > string origin controller action pro renderovani
                                            # spravne sablony (registrace, dokončení registrace, profil)
    @user = User.find_by(id: session_user)

    if @user.update_attributes(user_params)
      if @user.role == "guest"
        @user.role = User.roles["registered"]
        GoogleAnalyticsApi.new.event('users', 'registered - guest', '', params[:ga_user_id], location: request.url, user_type: 'guest')
      end
      @user.save
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
      redirect_to registration_path
    end
  end

  def invite
    #TODO flash s tím kde může spravovat pozvánky
    #TODO ošetřit, že nemůže pozvat sám sebe
    #TODO přesunout pozvánky do List controlleru kvůli ukládání dat k seznamu

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

  private

  def user_params
    params.require(:user).permit(:name, :email, :surname, :password, :password_confirmation)
  end
end
