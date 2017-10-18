# frozen_string_literal: true
require 'rails_helper'

RSpec.feature 'Sessions', type: :feature do
  let(:user)  { create(:user) }

  scenario 'User logs in without credentials' do
    visit login_path
    fill_in 'email', with: 'neco@neco.neco'
    click_button 'login'

    expect(page).to have_text(I18n.t('sessions.create.credentials_mismatch'))
  end

  scenario 'User logs in with correct credentials' do
    visit login_path
    login(user)

    expect(current_path).to eq lists_path
  end

  scenario 'User logs in and out' do
    visit login_path
    login(user)
    logout(user)

    expect(current_path).to eq '/'
  end

  scenario 'User submits email for password recovery' do
    visit password_recovery_path
    fill_in 'email', with: 'neco@neco.neco'
    click_button 'form_submit'

    expect(page).to have_text(I18n.t('users.recover_password.password_recovery'))
  end

end
