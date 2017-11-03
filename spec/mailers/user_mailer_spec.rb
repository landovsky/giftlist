# frozen_string_literal: true
require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  describe '.test_email' do
    let(:email) do
      job = UserMailer.delay.test_email
    end

    it 'renders the headers' do
      expect(email.to).to eq(%w(landovsky@gmail.com))
    end

    it 'renders the body' do
      expect(email.body.encoded).to match(/Bella vista/)
    end
  end

  describe '.invitation_email' do
    let(:list)  { create(:list_with_guests) }
    let(:email) { described_class.invitation_email(user: list.invitees.last, list: list).deliver_now }

    it 'renders the headers' do
      expect(email.to).to eq([list.invitees.last.email.to_s])
    end

    it 'renders the body' do
      expect(email.body.encoded).to match(/nejsp=C3=AD=C5=A1 nejsi s=C3=A1m kdo pozv=C3=A1nku dostal/)
    end
  end

  describe '.reservations_email' do
    let(:recipient) { create(:user) }
    let(:email)     { described_class.reservations_email(recipient).deliver_now }

    it 'renders the headers' do
      expect(email.to).to eq([recipient.email.to_s])
    end

    context 'when user has no reservations' do
      it 'does not render any gifts' do
        expect(email.body.encoded).to match(/U=C5=BE nem=C3=A1=C5=A1 =C5=BE=C3=A1dn=C3=A9 rezervace/)
      end
    end

    context 'when user has reservations' do
      let(:list)  { create(:list_with_guests) }
      let(:email) { described_class.reservations_email(list.invitees.last).deliver_now }

      it 'renders reserved gifts' do
        expect(email.body.encoded).to match(/Pro p=C5=99ipomenut=C3=AD ti pos=C3=ADl=C3=A1me seznam/)
      end
    end
  end

  describe '.recover_password_email' do
    let(:recipient)   { create(:user) }
    let(:email)       { described_class.recover_password_email(recipient, recipient.token_for_list) }

    it 'generates email with token in a link' do
      expect(email.body.encoded).to match(/reset_password\?t=[a-zA-Z0-9]{8}/)
    end
  end
end
