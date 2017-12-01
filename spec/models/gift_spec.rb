# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Gift, type: :model do
  describe 'associations' do
    it { should belong_to :list }
    it { should have_many :urls }
    it { should belong_to(:donor).class_name('User') }
  end

  describe '.bind_loose_urls' do
    let!(:list)    { create(:list, :associations) }
    let!(:gift)    { create(:gift, list_id: list.id) }
    let!(:url)     { create(:url, list_id: list.id) }  
    
    it 'associates loose urls with gift' do
      gift.bind_loose_urls
      url.reload
      expect(url.gift).to eq gift
    end
  end
end
