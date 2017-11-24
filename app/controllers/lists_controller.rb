class ListsController < ApplicationController
  before_action :set_list_context, only: [:show, :destroy]

  def new
  end

  def create
    lp = list_params
    lp[:occasion] = lp[:occasion].to_i
    #zajisti, ze se nastavi list.error.message kdyz user nevybere occasion
    lp[:occasion] = nil if lp[:occasion] == 0
    lp[:user_id] = current_user.id
    lp[:occasion_date] = "24-12-#{Time.now.strftime("%Y")}" if lp[:occasion] == List.occasions["vánoce"]

    @list = List.new(lp).decorate

    if @list.save
      #TODO ošetřit, že ga_user_id nemusí být JavaScriptem nastaveno
      params[:ga_user_id] ? params[:ga_user_id] : params[:ga_user_id] = '555'
      GoogleAnalyticsApi.new.event('lists', 'list created', @list.occasion, params[:ga_user_id], location: request.url)
      flash[:success] = "uloženo"
      flash.discard
      @lists = List.owned_by(current_user)
      redirect_to :action => 'show', id: @list.id
    else
      @lists_owned = List.owned_by(current_user).decorate
      @lists_invited = List.invited(current_user).decorate
      #nastavit vybranou prilezitost
      @selected = List.occasions[@list.occasion] if List.occasions.include?@list.occasion
      #nebo nastavit "vyberte" hodnotu
      @selected ||= 0
      render 'index' and return
    end
  end

  def destroy
    if @list.destroy
      flash[:success] = "Tvůj seznam jsme smazali."
      redirect_to root_path
    else
      flash[:success] = "chyba"
      redirect_to list_path(@list.id)
    end
  end

  def index
    @list = List.new.decorate
    # vybrat hodnotu "vyberte" occasion type
    @selected = 0
    @lists_owned = List.owned_by(current_user).decorate
    @lists_invited = List.invited(current_user).decorate
  end

  def show
    @list = List.authentic?(params[:id], current_user.id)
    if @list
      @gifts = Gift.eager_load(:urls).where(list_id: @list.id).order(:user_id).decorate
      @urls = @gifts.map(&:urls)
      @gift = Gift.new(list: @list)
      @invitees = @list.invitees.decorate #dekorace kvůli zobrazení v seznamu dárců (registrovaní v. neregistrovaní)
      @list = @list.decorate
      #@fake = "landovsky@gmail.com" if ["development", "stage"].include?Rails.env #
      @fake = fake_email(2) unless Rails.env == "production"
    else
      redirect_to :action => 'index' and return
    end
  end

  private

  def list_params
    params.require(:list).permit(:occasion, :occasion_of, :occasion_date, :id, :occasion_data)
  end

  def set_list_context
    @list = List.authentic?(params[:id], current_user.id)
    @list_type = @list.occasion
  end

end
