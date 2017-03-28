class Url < ApplicationRecord
  belongs_to :gift
  serialize :data
end
