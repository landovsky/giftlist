# frozen_string_literal: true

module UserHelper
  def login(user)
    visit login_path
    fill_in 'email', with: user.email
    fill_in 'password', with: 'Heslo123'
    click_button 'login'
  end

  def logout(_user)
    visit logout_path
  end

  def activate(user)
    visit activate_path(code: user.activation_code)
  end
end
