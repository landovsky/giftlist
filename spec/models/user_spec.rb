require 'rails_helper'

RSpec.describe User, type: :model do

  describe '.token_for_list' do
    let(:user)    { create(:user) }

    #TODO testy: naučit se testovat JsonWebToken, který testuju v User modelu
    it 'creates a valid token' do
      token = user.token_for_list
      expect(JsonWebToken.expired?(token)).to be false
    end

    it 'renders token invalid after passage of default time' do
      token = user.token_for_list
      Timecop.freeze(25.hours.from_now.localtime) do
        expect(JsonWebToken.expired?(token)).to be true
      end
    end
  end

  describe '.find_by_token' do
    let(:user)    { create(:user) }

    context 'when valid token is provided' do
      it 'returns user from database' do
        token = user.token_for_list
        expect(described_class.find_by_token(token)).to eq(user)
      end
    end

    context 'when token expires' do
      it 'does not return user' do
        token = user.token_for_list
        Timecop.freeze(25.hours.from_now.localtime) do
          expect(described_class.find_by_token(token)).to be false
        end
      end
    end
  end

end
