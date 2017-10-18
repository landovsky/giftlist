# frozen_string_literal: true
require 'rails_helper'

RSpec.feature 'Gifts', type: :feature do
  let(:user)  { create(:user) }
  let!(:list) { create(:list, occasion: 2, user_id: user.id) }

  describe 'User can' do
    let!(:list) { create(:list, occasion: 2, user_id: user.id) }
    let!(:gift) { create(:gift, name: 'koloběžka', list_id: list.id) }
    before      { login(user) }

    scenario 'add gift to his list' do
      click_link_or_button 'narozeniny'

      fill_in 'gift_name',          with: 'můj dárek'
      fill_in 'gift_description',   with: 'co bych si přál'
      fill_in 'gift_price_range',   with: 'za 200 kila'
      click_button 'submit_gift_form'

      expect(current_path).to include lists_path
      expect(page).to have_selector(:link_or_button, 'můj dárek')
      expect(page).to have_text('co bych si přál')
      expect(page).to have_text('za 200 kila')
    end

    scenario 'update existing gift' do
      click_link_or_button 'narozeniny'
      click_link_or_button 'koloběžka'

      fill_in 'gift_name',          with: 'můj dárek'
      fill_in 'gift_description',   with: 'co bych si přál'
      fill_in 'gift_price_range',   with: 'za 200 kila'
      click_button 'submit_gift_form'

      expect(current_path).to include lists_path
      expect(page).to have_selector(:link_or_button, 'můj dárek')
      expect(page).to have_text('co bych si přál')
      expect(page).to have_text('za 200 kila')
    end

    scenario 'add url to existing gift'

    scenario 'reserve gift', js: true do
      click_link_or_button 'narozeniny'
      click_link_or_button 'take'

      expect(page).to have_selector(:link_or_button, 'untake')
    end

    scenario 'unreserve gift', js: true do
      click_link_or_button 'narozeniny'
      click_link_or_button 'take'
      click_link_or_button 'untake'

      expect(page).to have_selector(:link_or_button, 'take')
    end
  end

  describe 'Guest can' do
    let(:guest) { create(:guest) }
    before do
      list.invite(guest)
      login(guest)
    end

    scenario 'reserve gift', js: true do
      create(:gift, name: 'koloběžka', list_id: list.id)

      click_link_or_button 'narozeniny'
      click_link_or_button 'take'

      expect(page).to have_selector(:link_or_button, 'untake')
    end

    scenario 'unreserve gift', js: true do
      create(:gift, name: 'koloběžka', list_id: list.id)

      click_link_or_button 'narozeniny'
      click_link_or_button 'take'
      click_link_or_button 'untake'

      expect(page).to have_selector(:link_or_button, 'take')
    end

    scenario 'not reserve gift reserved by someone' do
      create(:gift, name: 'koloběžka', list_id: list.id, user_id: user.id)

      click_link_or_button 'narozeniny'

      expect(page).not_to have_selector(:link_or_button, 'take')
    end
  end
end
