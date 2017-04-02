class SessionsController < ApplicationController
  skip_before_action :authorize
  def new
  end

  def token_auth
    #TODO token sign-in: donutit uživatele se přihlásit když už má registraci? (asi jo, kdyby někdo odkaz zneužil tak ať nemůže smazat jeho seznamy)
    token = JsonWebToken.decode(params[:t])

    if token != nil
      user = User.find_by_id(token[:user_id])
    else
      flash[:danger] = "Neplatný přihlašovací odkaz."
      flash.discard
      render 'new' and return
    end

    if user
      session[:user_id] = user.id
      redir = '/'
      redir = list_path(token[:list_id]) if token.keys.include?("list_id") && !token[:list_id].blank?
      redirect_to redir
    else
      flash[:danger] = "Neplatný přihlašovací odkaz."
      flash.discard
      render 'new'
    end
  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      session[:pre_login_path] ||= lists_path
      redirect_to session[:pre_login_path]
    else
      if user
        logger.warn { "Failed login attempt of user id #{user.id} (#{user.full_name})" }
      else
        logger.warn { "Failed login attempt with #{params[:email]} / #{params[:password]}" }
      end
      flash[:danger] = "Kombinace přihlašovacího jména a hesla nesedí."
      flash.discard
      render 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    session[:pre_login_path] = nil
    redirect_to '/'
  end

end