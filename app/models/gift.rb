class Gift < ApplicationRecord
  belongs_to :list
  validates_presence_of :list

  belongs_to :donor, :class_name => 'User', :foreign_key => 'user_id', optional: true
  
  validates :name, presence: { message: "něco si přeju, ale jak se to jen řekne..." }
  
  def associate_to_list(list_id)
    if List.find_by(id: list_id) == nil
      return false
    else
      self.list = list_id
    end
    
  end
end
