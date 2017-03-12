class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  protect_from_forgery with: :exception
  #conditional before_action http://stackoverflow.com/questions/23368424/documentation-for-conditional-before-action-before-filter
end
