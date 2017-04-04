require 'email_checker'
require 'json_web_token'


class UsersController < ApplicationController
  #TODO vyřešit přístup k seznamu uživatelů bez přihlášení...asi v routes.rb
  skip_before_action :authorize

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
  end

  def invite
    #vstupy: list_id, adresy
    #flash s tím kde může spravovat pozvánky
    @list = List.authentic?(params[:list_id], current_user.id)
    if !@list
      redirect to '/' and return
    end
    emails = EmailChecker.new(params[:emails])
    @new_donors = []
    @valid = emails.valid
    @valid.each do |e|
      @user = User.find_or_create_by(email: e) do |u|
        u.role = 0
        u.password_digest = "empty"
      end
      logger.warn { "before email" }
      UserMailer.invitation_email(@list, @user).deliver_later if !@list.donors.include?(@user)
      logger.warn { "after email" }
      @new_donors << @user
      @list.donors << @user
    end 
    @list = @list.decorate
    @invalid = emails.invalid.join(", ")

  end

  def uninvite

  end

  def create
    @user = User.new(user_params)
    @user.role = User.roles["registered"]
    if @user.save
      session[:user_id] = @user.id
      redirect_to '/'
    else
      @user_name = @user.name
      @user_surname = @user.surname
      @user_email = @user.email
      flash_msg = String.new
      @user.errors.messages.each { |key,val| val.each do |v| flash_msg << "#{v}</br>" end }
      flash[:danger] = flash_msg
      flash.discard

      render 'new', :status => :bad_request
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :surname, :password, :password_confirmation)
  end
end