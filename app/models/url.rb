class Url < ApplicationRecord
  #TODO zajistit automatické smazání Url při smazání dárku

  belongs_to :gift
  serialize :data

  validates :digest, uniqueness: true
  
  def image_src
    if self.data[:images].blank?
      return false
    else
      @image_src = self.data[:images][0][:src]
    end
  end

end
