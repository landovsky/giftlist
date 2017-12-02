class Url < ApplicationRecord
  #TODO zajistit automatické smazání Url při smazání dárku

  belongs_to :gift
  belongs_to :list
  serialize  :data

  scope :loose, -> { where(gift_id: nil) }

  validates :digest, uniqueness: { scope: :gift_id }

  def image_src
    # TODO: doplnit default na lokalni ikonu pokud fotka neexistuje
    return false if self.data[:images].blank?
    data[:images][0][:src]
  end

  def authentic?(current_user)
    return false if list_id.blank? && gift_id.blank?
    return gift.list.owner == current_user if gift_id
    return list.owner == current_user if list_id
  end

  def src
    self.data[:url]
  end

  def self.bind_loose(list_id:, gift_id:)
    data = { list_id: nil, gift_id: gift_id }
    loose.where(list_id: list_id).update_all(data)
  end
end
