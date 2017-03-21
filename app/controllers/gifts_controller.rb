class GiftsController < ApplicationController
  def index
  end

  def new
    @list = List.authentic?(params[:list_id], current_user.id)
    if @list
      @gift = Gift.new(list: @list)
      @list_id = params[:list_id]
    else
      redirect_to lists_path
    return
    end
  end

  def create
    @gift = Gift.new(gift_params)

    if @gift.save
      redirect_to list_path(id: @gift.list_id)
    else
      render 'new'
    end
  end

  def show
  end

  def grab
  end

  def release
  end

  def destroy
    @gift = Gift.find_by(id: params[:id])
    if @gift.destroy
      redirect_to list_path(id: @gift.list_id)
    else
      flash[:danger] = "nešlo to smazat"
      render 'edit'
    end
  end

  def edit
    #TODO udělat gift.authentic? na kontrolu jestli dárek existuje a user se na něj může dívat
    @gift = Gift.find_by(id: params[:id])
    @list = @gift.list
  end

  def update
    @gift = Gift.find_by(id: params[:id])
    if @gift.update_attributes(gift_params)
      redirect_to list_path(id: @gift.list_id)
    else
      render 'edit'
    end
  end

  private

  def gift_params
    params.require(:gift).permit(:name, :description, :price_range, :list_id)
  end

end