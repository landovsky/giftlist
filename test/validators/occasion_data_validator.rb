require 'test_helper'

class OccasionDataValidatable
  include ActiveModel::Validations
  validates_with OccasionDataValidator, :attributes=>[:occasion_data]
  attr_accessor  :occasion_data
end

class OccasionDataValidatorTest < Minitest::Test
  def test_invalidates_object_for_empty_occasion_data_other
    obj = OccasionDataValidatable.new
    obj.occasion_data = ""
    refute obj.valid?
  end
end