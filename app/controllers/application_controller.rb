class ApplicationController < ActionController::Base
  before_action :authorize
  #protect_from_forgery with: :exception
  #conditional before_action http://stackoverflow.com/questions/23368424/documentation-for-conditional-before-action-before-filter

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def current_controller(controller)
    Rails.application.routes.recognize_path(request.original_url)[:controller] == controller    
  end
  helper_method :current_controller

  def authorize
  	session[:pre_login_path] = request.fullpath unless current_user
    redirect_to '/login' unless current_user
  end

end
