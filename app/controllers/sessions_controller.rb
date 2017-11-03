# frozen_string_literal: true
class SessionsController < ApplicationController
  skip_before_action :authorize
  def new; end

  def token_auth
    # TODO: token sign-in: implementovat User.find_by_token
    # TODO token sign-in: donutit uživatele se přihlásit když už má registraci?
    # (asi jo, kdyby někdo odkaz zneužil tak ať nemůže smazat jeho seznamy)
    token = JsonWebToken.decode(params[:t])

    if token.nil? # neplatný token
      GoogleAnalyticsApi.new.event('users', 'login - failure', 'token', 555, location: request.url)
      flash[:danger] = 'Neplatný přihlašovací odkaz.'
      flash.discard
      render('new') && return
    # dohledani uzivatele podle user.id z tokenu
    else
      user = User.find_by_id(token[:user_id])
    end

    # platny uzivatel
    if user
      session[:user_id] = user.id
      GoogleAnalyticsApi.new.event('users', 'login - success', 'token', 555, location: request.url)
      redir = '/'
      if token.keys.include?('answer')
        MyLogger.logme('Kampan: lidi bez seznamu', "user: #{user.id}, odpoved: #{token[:answer]}", level: 'warn')
        redir = thank_you_path unless token[:answer] == 'now'
      end
      if token.keys.include?('list_id') && !token[:list_id].blank?
        redir = list_path(token[:list_id])
      else
        MyLogger.logme('SECURITY', 'přístup do systému s tokenem bez list_id', level: 'warn')
      end
      redirect_to redir
    # neplatný token nebo neexistující uživatel
    else
      flash[:danger] = 'Neplatný přihlašovací odkaz.'
      flash.discard
      render 'new'
    end
  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      session[:pre_login_path] ||= lists_path
      params[:ga_user_id] ? params[:ga_user_id] : params[:ga_user_id] = '555'
      GoogleAnalyticsApi.new.event('users', 'login - success', 'password', params[:ga_user_id], location: request.url)
      redirect_to session[:pre_login_path]
    else
      if user
        params[:ga_user_id] ? params[:ga_user_id] : params[:ga_user_id] = '555'
        GoogleAnalyticsApi.new.event('users', 'login - failure', 'password', params[:ga_user_id], location: request.url)
        logger.warn { "Failed login attempt of user id #{user.id} (#{user.full_name})" }
      else
        params[:ga_user_id] ? params[:ga_user_id] : params[:ga_user_id] = '555'
        GoogleAnalyticsApi.new.event('users', 'login - failure', 'credentials', params[:ga_user_id], location: request.url)
        logger.warn { "Failed login attempt with #{params[:email]} / #{params[:password]}" }
      end
      flash[:danger] = I18n.t('sessions.create.credentials_mismatch')
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
