# frozen_string_literal: true
require 'rails_helper'

RSpec.describe List, type: :model do
  describe 'associations' do
    it { should have_many :gifts }
    it { should have_many(:invitees).through(:invitation_lists).source(:user) }
  end

  describe '.owned_by' do
    let(:list) { create(:list, :associations) }

    it 'shows lists owned by a user' do
      expect(described_class.owned_by(list.owner.id).count).to eq(1)
    end
  end

  describe '.invited' do
    let(:list) { create(:list_with_guests) }

    it 'shows lists to which a user has been invited' do
      expect(described_class.invited(list.invitees.last.id).count).to eq(1)
    end
  end

  describe '.invite' do
    let(:list)  { create(:list, :associations) }
    let(:guest) { create(:guest) }

    it 'adds user to invitees' do
      expect { list.invite(guest) }.to change { list.invitees.count }.by 1
    end
  end

  describe '.authentic?' do
    let(:user)  { create(:user_with_list) }
    let(:guest) { create(:guest) }
    let(:list)  { create(:list, :associations) }

    it 'returns list if user is owner' do
      expect(described_class.authentic?(user.lists.last.id, user.id)).to eq(user.lists.last)
    end

    it 'returns list if user is invitee' do
      list.invite(guest)
      expect(described_class.authentic?(list.id, guest.id)).to eq(list)
    end

    it 'returns false if user is not owner neither invitee' do
      expect(described_class.authentic?(list.id, user.id)).to be false
    end

    it 'returns false if integers cannot be derived from arguments' do
      expect(described_class.authentic?('abc', 'cde')).to be false
    end
  end

  context 'when deleted' do
    let!(:user) { create(:user_with_list) }

    it 'does not leave any orphaned gifts' do
      expect { user.lists.last.destroy }.to change { Gift.count }
    end
  end
end
