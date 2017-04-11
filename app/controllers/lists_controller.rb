class ListsController < ApplicationController

  def new
  end

  def create
    @list = List.new(list_params)
    @list.owner = current_user

    if @list.save
      flash[:success] = "uloženo"
      flash.discard
      @lists = List.owned(current_user)
      redirect_to :action => 'show', id: @list.id
    else
      @lists_owned = List.owned(current_user)
      @lists_invited = List.invited(current_user)
      render 'index'
    end
  end

  def index
    @list = List.new
    @lists_owned = List.owned(current_user).decorate
    @lists_invited = List.invited(current_user).decorate
  end

  def show
    @list = List.authentic?(params[:id], current_user.id)
    if @list
      @gifts = Gift.eager_load(:urls).where(list_id: @list.id)
      #@gifts = GiftDecorator.decorate_collection(Gift.eager_load(:urls).where(list_id: @list.id))
      @urls = @gifts.map(&:urls)
      #@urls = UrlDecorator.decorate_collection(@urls)
      @gift = Gift.new(list: @list)
      @donors = @list.donors.decorate #dekorace kvůli zobrazení v seznamu dárců (registrovaní v. neregistrovaní)
      @list = @list.decorate
      @fake = fake_email(2) if ["development", "stage"].include?Rails.env
    else
      redirect_to :action => 'index'
    return
    end
  end

  private

  def list_params
    params.require(:list).permit(:occasion, :occasion_of, :occasion_date, :id)
  end

end
