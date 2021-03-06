# frozen_string_literal: true
class UserCampaign
  def self.registered_without_list_campaign
    users = User.includes(:lists).where(role: 'registered', lists: { user_id: nil })
    users.each do |user|
      UserMailer.registered_without_list_email(user).deliver_now
      MyLogger.logme('Kampan: lidi bez seznamu', "posláno - #{user.id}", level: 'warn')
    end
  end
end
