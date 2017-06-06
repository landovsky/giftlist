class LoggedInConstraint
  def matches?(request)
    logged_in?(request)
  end

  def logged_in?(request)
    request.session[:user_id].present?
  end
end
