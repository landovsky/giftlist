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
    @origin = eval(params[:origin])[:value]
    @user = User.new(user_params)
    @user.role = User.roles["registered"]
    if @user.save
      session[:user_id] = @user.id
      redirect_to '/'
    else
      #@user_name = @user.name
      #@user_surname = @user.surname
      #@user_email = @user.email
      render @origin
    end
  end

  def update
    #FIXME update profilu nelze uložit bez zadání hesla
    @origin = eval(params[:origin])[:value] # hash > string origin controller action pro renderovani spravne sablony
    @user = User.find_by(id: session_user)     
     
    if @user.update_attributes(user_params)
      @user.role = User.roles["registered"] if @user.role == "guest"
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
    @list = List.authentic?(params[:list_id], current_user.id)
    if !@list
      raise 'List not authentic'
      redirect to '/' and return    
    end
    emails = EmailChecker.new(params[:emails])
    @new_donors = []
    @valid = emails.valid
    @valid.each do |e|
      @user = User.find_or_create_by(email: e) do |u|
        u.role = 0
        u.password = "empty"
        u.password_digest = "empty"
      end
      #TODO proč tam mám tu podmínku na list.donors.include?user
      UserMailer.invitation_email(@list, @user).deliver_later if !@list.donors.include?(@user)
      @new_donors << @user
      @list.donors << @user
    end 
    @list = @list.decorate
    @invalid = emails.invalid.join(", ")
  end

  def uninvite
    @list = List.authentic?(params[:list_id], current_user.id)
    @list.donors.count
    if !@list
      raise "List not authentic"
      redirect_to '/' and return
    end
    #TODO ošetřit že na to někdo klikne dvakrát a už nebude co mazat
    InvitationList.find_by(user_id: params[:user_id], list_id: @list.id).destroy
    @donor_id = params[:user_id]
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :surname, :password, :password_confirmation)
  end
end