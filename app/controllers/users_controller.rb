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