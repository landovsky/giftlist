class ListsController < ApplicationController

  def new
  end

  def create
    lp = list_params
    lp[:occasion] = lp[:occasion].to_i
    lp[:occasion] = nil if lp[:occasion] == 0 #zajisti, ze se nastavi list.error.message kdyz user nevybere occasion
    lp[:user_id] = current_user.id
    lp[:occasion_date] = "24-12-#{Time.now.strftime("%Y")}" if lp[:occasion] == List.occasions["vánoce"]
  
    @list = List.new(lp).decorate
      
    if @list.save
      flash[:success] = "uloženo"
      flash.discard
      @lists = List.owned(current_user)
      redirect_to :action => 'show', id: @list.id
    else
      @lists_owned = List.owned(current_user).decorate
      @lists_invited = List.invited(current_user).decorate
      @selected = List.occasions[@list.occasion] if List.occasions.include?@list.occasion #nastavit vybranou prilezitost
      @selected ||= 0 #nebo nastavit "vyberte" hodnotu
      render 'index' and return
    end
  end

  def index
    @list = List.new.decorate
    @selected = 0 #vybrat hodnotu "vyberte" occasion type
    @lists_owned = List.owned(current_user).decorate
    @lists_invited = List.invited(current_user).decorate
  end

  def show
    @list = List.authentic?(params[:id], current_user.id)
    if @list
      @gifts = Gift.eager_load(:urls).where(list_id: @list.id).decorate
      @urls = @gifts.map(&:urls)
      @gift = Gift.new(list: @list)
      @invitees = @list.invitees.decorate #dekorace kvůli zobrazení v seznamu dárců (registrovaní v. neregistrovaní)
      @list = @list.decorate
      @fake = fake_email(2) if ["development", "stage"].include?Rails.env
    else
      redirect_to :action => 'index' and return
    end
  end

  private

  def list_params
    params.require(:list).permit(:occasion, :occasion_of, :occasion_date, :id, :occasion_data)
  end

end
