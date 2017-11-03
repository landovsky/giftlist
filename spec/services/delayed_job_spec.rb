# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Delayed::Job do
  let(:user)      { create(:user_with_list) }
  let(:list)      { user.lists.first }
  let(:recipient) { list.invitees.first }
  before { Delayed::Worker.delay_jobs = false }
  after  { Delayed::Worker.delay_jobs = true }

  context 'with valid arguments' do
    it 'dispatches invitation email to guest' do
      job = UserMailer.delay.invitation_email(user: recipient, list: list)

      expect(job.failed_at).to be(nil)
    end

    it 'dispatches invitation email to user' do
      job = UserMailer.delay.invitation_email(user: user, list: list)

      expect(job.failed_at).to be(nil)
    end
  end

  context 'with invalid arguments' do
    it 'raises exception' do
      expect { UserMailer.delay.invitation_email(user: user, list: List.new) }.to raise_error(NoMethodError)
      expect { UserMailer.delay.invitation_email(user: "recipient", list: list) }.to raise_error(NoMethodError)
    end
  end
end
