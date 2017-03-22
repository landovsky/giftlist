class StatsController < ApplicationController
  def index
  if session[:user_id] = 1
    @users = User.all
    @lists = List.all
  else
     redirect_to home_path
  end
end
