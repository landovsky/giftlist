class Url < ApplicationRecord
  #TODO zajistit automatické smazání Url při smazání dárku

  belongs_to :gift
  serialize :data

  validates :digest, uniqueness: true

end
