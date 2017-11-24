# frozen_string_literal: true
require 'rails_helper'

RSpec.feature 'Sessions', type: :feature do
  let(:user)  { create(:user_with_list) }
  before      { login(user) }

  scenario 'User can open detail of existing list' do
    click_link_or_button 'narozeniny'

    expect(current_path).to include lists_path
    expect(page).to have_text('narozeniny')
  end

  scenario 'User can create new list' do
    select 'svatba',            from: 'occasion_type'
    fill_in 'list_occasion_of', with: 'asdf'
    fill_in 'datepicker',       with: 10.days.from_now
    click_button 'form_submit'

    expect(page).to have_text(I18n.t('gifts.i_wish'))
  end

  scenario 'User can invite others to his list', js: true do
    click_link_or_button 'narozeniny'
    click_link_or_button 'invitation_btn'
    fill_in 'emails', with: 'neco@neco.neco'
    click_button 'submit_invite_form'

    expect(page).to have_selector(:link_or_button, 'neco@neco.neco')
  end

  scenario 'User can delete his own list', js: true do
    expect(page).to have_text('jájenjá')
    click_link_or_button 'narozeniny'
    accept_confirm { click_link 'smazat' }

    expect(page).not_to have_text('jájenjá')
  end

  scenario 'User cannot delete list of other' do
  end
end
