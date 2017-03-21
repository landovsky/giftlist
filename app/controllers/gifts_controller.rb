class GiftsController < ApplicationController
  def index
  end

  def new
    @list = List.authentic?(params[:list_id], current_user.id)
    if @list
      @gift = Gift.new
    @gift.list = @list
    else
      redirect_to 'lists/index'
    return
    end
  end

  def create
    @gift = Gift.new(gift_params)
    @gift.associate_to_list(params[:list_id])
    if @gift.save
      flash[:success] = "uloženo"
      flash.discard
      render "lists/index"
    else
      flash[:danger] = "něco se pokazilo"
      flash.discard
      render "lists/index"
    end
  end

  def show
  end

  def grab
  end

  def release
  end

  def destroy
  end

  def edit
  end

  def update
  end

  private

  def gift_params
    params.require(:gift).permit(:name, :description, :price_range, :list_id)
  end

end