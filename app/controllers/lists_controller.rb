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
    @lists_owned = List.owned(current_user)
    @lists_invited = List.invited(current_user)
  end

  def show
    @list = List.authentic?(params[:id], current_user.id)
    if @list
      @gifts = @list.gifts
      @gift = Gift.new(list: @list)
      #TODO proč dekoruju list.donors?
      @donors = @list.donors.decorate
      @list = @list.decorate
    else
      redirect_to :action => 'index'
    return
    end
  end

  private

  def list_params
    params.require(:list).permit(:occasion, :occasion_of, :id)
  end

end
