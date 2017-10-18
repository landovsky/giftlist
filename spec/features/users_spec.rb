# frozen_string_literal: true
require 'rails_helper'

RSpec.feature 'Users', type: :feature do
  let(:user)  { create(:user) }
  before      { login(user) }

  scenario 'Existing user cannot register again' do
    visit logout_path
    visit registration_path
    fill_in 'email', with: user.email
    click_button 'form_submit'

    expect(page).to have_text(I18n.t('users.create.user_exists'))
  end

  scenario 'Logged-in user can visit user profile' do
    visit profile_path

    expect(page).to have_text(I18n.t('users.profile.title'))
  end

  scenario 'Logged-in user can update his profile' do
    visit profile_path
    fill_in 'user_name',                  with: 'Johny'
    fill_in 'user_surname',               with: 'Walker'
    fill_in 'user_email',                 with: 'email@new.new'
    fill_in 'user_password',              with: 'pwd123'
    fill_in 'user_password_confirmation', with: 'pwd123'
    click_button 'form_submit'

    expect(page).to have_text(I18n.t('users.update.saved'))
  end

  scenario 'New user can register'
end
