class List < ApplicationRecord
  belongs_to :owner, :class_name => 'User', :foreign_key => 'user_id'
  validates_presence_of :owner

  has_many :donors, through: :invitation_lists, :source => :user
  has_many :invitation_lists
  has_many :gifts

  validates :occasion, presence: { message: "vyplňte příležitost (např. svatba, vánoce, ..)" }
  validates :occasion_of, presence: { message: "vyplňte obdarovaného (např. já, sestra, ..)" }
  
  def self.owned(user_id)
    self.where(user_id: user_id)
  end

  def self.invited(user_id)
    self.joins(:invitation_lists).where(invitation_lists: { user_id: user_id})
  end
  
  def self.authentic?(list_id, user_id)
    list_id = list_id.to_i
    return false if list_id == 0
    @list = self.find_by(id: list_id)
    return false if @list == nil #list does not exist
    return false if @list.user_id != user_id && !@list.donors.map(&:id).include?(user_id) #supplied user_id is not owner nor donor
    @list
  end 

end
