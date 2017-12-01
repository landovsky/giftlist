# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Url, type: :model do
  describe 'associations' do
    it { should belong_to :gift }
    it { should belong_to :list }
  end

  describe 'scopes' do
    describe 'loose' do
      let(:gift_with_url) { create(:gift, :associations) }
      let(:loose_url)     { create(:url) }

      it 'shows urls without gift association' do
        expect(Url.loose).to include loose_url
      end

      it 'does not show urls with gift association' do
        bound_url = gift_with_url.urls.first
        expect(Url.loose).to include loose_url
        expect(Url.loose).not_to include bound_url
      end
    end
  end

  describe '.authentic?' do
      let(:gift_with_url)       { create(:gift, :associations) }
      let(:gift_with_url_cizi)  { create(:gift, :associations) }
      let(:url_with_gift)       { gift_with_url.urls.first }
      let(:url_with_gift_cizi)  { gift_with_url_cizi.urls.first }
      let(:user)                { gift_with_url.list.owner }
      let(:url_with_list)       { create(:url, list_id: gift_with_url.list_id) }
      let(:url_with_list_cizi)  { create(:url, list_id: gift_with_url_cizi.list_id) }
      let(:loose_url)           { create(:url) }

    it 'returns false if url does not belong to current user' do
      expect(loose_url.authentic?(user)).to be false
    end

    context 'when url belongs to list' do
      it 'returns true if url belongs to current_user' do
        expect(url_with_list.authentic?(user)).to be true
      end

      it 'returns false if url does not belong to current user' do
        expect(url_with_list_cizi.authentic?(user)).to be false
      end
    end

    context 'when url belongs to gift' do
      it 'returns true if url belongs to current_user' do
        expect(url_with_gift.authentic?(user)).to be true
      end

      it 'returns false if url does not belong to current user' do
        expect(url_with_gift_cizi.authentic?(user)).to be false
      end
    end
  end

  describe 'self.bind_loose' do
    skip 'missing'
  end
end
