class StatsController < ApplicationController
  def index
  @users = User.all
  @lists = List.all

  end
end
