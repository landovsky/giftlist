class StatsController < ApplicationController
  
  
  def index
    if User.find_by(id: session[:user_id]).email == "landovsky@gmail.com"
      @users = User.all
      @lists = List.all
    else
      redirect_to '/'
    end
  end
end
