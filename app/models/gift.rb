class Gift < ApplicationRecord
  belongs_to :list
  validates_presence_of :list

  belongs_to :donor, :class_name => 'User', :foreign_key => 'user_id', optional: true
  
  has_many :urls
  
  validates :name, presence: { message: "něco si přeju, ale jak se to jen řekne..." }
  
  def associate_to_list(list_id)
    if List.find_by(id: list_id) == nil
      return false
    else
      self.list = list_id
    end  
  end
  
  def taken?(id=0)
    return false if user_id.blank?
    return "self" if user_id == id
    return true if !user_id.blank?
  end
  
  #TODO optimize: 3 selecty na odbavení této metody, možná dlouhý join (až bude víc dat)
  def self.authentic?(gift_id, user_id)
    gift_id = gift_id.to_i
    return false if gift_id == 0
    @gift = self.find_by(id: gift_id)
    return false if @gift == nil #gift does not exist
    return false if !@gift.authorized_ids.include?(user_id)
    @gift
  end 
  
  def authorized_ids
    @ids = []
    @ids << user_id if user_id != nil # dárce (může být nil)
    @list = List.eager_load(:donors).find_by(id: self.list_id)
    @ids << @list.user_id # vlastník seznamu
    @list.donors.map(&:id).each do |n| @ids << n end # pozvaní do seznamu
    @ids.uniq
  end
  
  def self.id(id)
    find_by(id: id)    
  end
    
  def container_id
    "gift_cont#{id}"
  end

  def collapse_id
    "gift#{id}"
  end
  
  def panel_style
    if taken?
      "default"
    else
      "success"
    end
  end

  def taken_badge
    "<span class=\"label label-default\" style=\"position: relative; left: 5px; bottom: 2px\">zabráno</span>".html_safe if taken?
  end
  
end
