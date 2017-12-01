# frozen_string_literal: true

class List < ApplicationRecord
  belongs_to :owner, class_name: 'User', foreign_key: 'user_id'
  has_many :invitees, through: :invitation_lists, source: :user
  has_many :invitation_lists, dependent: :destroy
  has_many :gifts, dependent: :destroy
  has_many :urls

  enum occasion: { 'svatba' => 1, 'narozeniny' => 2, 'vánoce' => 3, 'jiná' => 99 }

  validates_presence_of :owner
  validates :occasion, presence: { message: 'K jaké příležitosti?' }
  validates :occasion_of, presence: { message: 'Kdo je obdarovaný?' }
  validates :occasion_date, presence: { message: 'Kdy se slaví?' }

  scope :active, -> { where("occasion_date > ?", 10.days.ago) }

  def self.owned_by(user_id)
    where(user_id: user_id)
  end

  def self.invited(user_id)
    joins(:invitation_lists).where(invitation_lists: { user_id: user_id })
  end

  def self.authentic?(list_id, user_id)
    list_id = list_id.to_i
    user_id = user_id.to_i
    return false if list_id.zero? || user_id.zero?
    list = find_by(id: list_id)
    return false unless list
    allowed_users = []
    allowed_users << list.owner.id
    allowed_users << list.invitees.map(&:id)
    return false unless allowed_users.flatten.include?(user_id)
    list
  end

  def self.id(id)
    find_by(id: id)
  end

  def self.occasion_by_id(id)
    List.occasions.select { |_key, value| value == id }.keys.first
  end

  def invite(user)
    invitees << user unless invitees.include?(user)
  end

  def owner?(session_user_id)
    # logger.debug { "DB load list.owner? method" }
    user_id == session_user_id
  end
end
