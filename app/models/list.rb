class List < ApplicationRecord
  belongs_to :owner, :class_name => 'User', :foreign_key => 'user_id'
  has_many :invitees, through: :invitation_lists, :source => :user
  has_many :invitation_lists
  has_many :gifts

  enum occasion: { "svatba" => 1, "narozeniny" => 2, "vánoce" => 3, "jiná" => 99 }

  validates_presence_of :owner
  validates :occasion, presence: { message: "K jaké příležitosti?" }
  validates :occasion_of, presence: { message: "Kdo je obdarovaný?" }
  validates :occasion_date, presence: { message: "Kdy se slaví?"}
  validates :occasion_data, presence: { message: "Jaká jiná?"}, if: "occasion == List.occasion_by_id(99)"
  
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
    return false if @list.user_id != user_id && !@list.invitees.map(&:id).include?(user_id) #supplied user_id is not owner nor invitee
    @list
  end 

  def owner?(session_user_id)
    #logger.debug { "DB load list.owner? method" }
    user_id == session_user_id
  end

  def self.id(id)
    find_by(id: id)    
  end
 
  def self.occasion_by_id(id)
    List.occasions.select { |key,value| value == id }.keys.first
  end

end
