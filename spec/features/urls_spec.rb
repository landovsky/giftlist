# frozen_string_literal: true
require 'rails_helper'

RSpec.feature 'Urls', type: :feature, js: true do
  def local_port
    if Rack::Server.new.options[:Port] != 9292 # rals s -p PORT
      local_port = Rack::Server.new.options[:Port]
    else
      local_port = (ENV['PORT'] || '3000').to_i # ENV['PORT'] for foreman
    end
  end

  def set_up
    first(:xpath, '//a[text()="narozeniny"]').click
    fill_in 'url', with: url_data.url
    # to step out of url field for the js to kick in
    fill_in 'gift_name', with: 'ahoj'
  end

  def submit_form
    first('#submit_giftform').click
  end

  let(:user)  { create(:user) }
  let!(:list) { create(:list, occasion: 2, user_id: user.id) }
  let(:gift)  { create(:gift, name: 'koloběžka', list_id: list.id) }

  before      { login(user) }

  describe 'User can' do
    let(:url)       { build(:url) }
    let(:url_data)  { OpenStruct.new(url.data) }

    scenario 'add url to unsaved gift' do
      set_up
      
      expect(page).to have_text(url_data.title)
    end

    scenario 'remove url from unsaved gift' do
      set_up
      # wait for the url to be rendered on page
      sleep(1)
      first('.glyphicon-trash').click

      expect(page).not_to have_text(url_data.title)
    end

    scenario 'add url to existing gift' do
      gift
      click_link_or_button 'narozeniny'
      click_link_or_button 'koloběžka'
      fill_in 'url', with: url_data.url
      # to step out of url field for the js to kick in
      fill_in 'gift_name', with: 'ahoj'
      first('#submit_giftform').click

      expect(page).to have_text(url_data.title)
    end

    context 'when new gift form is submitted with errors' do
      it 'url is not lost' do
        first(:xpath, '//a[text()="narozeniny"]').click
        fill_in 'url', with: url_data.url
        # to step out of url field for the js to kick in
        fill_in 'gift_price_range', with: 'ahoj'
        submit_form
        expect(page).to have_text('něco si přeju, ale jak se to jen řekne')
        expect(page).to have_text(url_data.title)
      end
    end

    context 'when new gift form is saved' do
      scenario 'gift is attached to gift' do
        set_up
        submit_form

        expect(page).to have_text(url_data.title)
        expect(page).to have_text('ahoj')
      end
    end
  end
end
