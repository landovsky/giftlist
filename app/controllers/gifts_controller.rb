class GiftsController < ApplicationController
  def index
  end

  def new
    @list = List.authentic?(params[:list_id], current_user.id)
    if @list
      @list = @list.decorate
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

  def take #also un-take
    @gift = Gift.authentic?(gift_id: params[:id],user_id: current_user.id)
    if @gift
      if @gift.user_id.blank?
        @gift.user_id = current_user.id
      else
        @gift.user_id = nil
      end
      UserMailer.delay(run_at: 10.minutes.from_now.localtime, strategy: :delete_previous_duplicate ).reservations_email(User.id(session_user))
      @gift.save
      @gift.reload
      @list = @gift.list #kvůli podmíněnému zobrazení ikony koše
    else
      redirect_to '/' and return
    end
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
    @list = @gift.list.decorate
    @urls = @gift.urls
  end

  def update
    @gift = Gift.eager_load(:list).find_by(id: params[:id])
    if @gift.update_attributes(gift_params)
      @gift.decorate
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
