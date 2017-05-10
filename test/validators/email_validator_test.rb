require 'test_helper'

class EmailValidatable
  include ActiveModel::Validations
  validates_with EmailValidator, :attributes=>[:email]
  attr_accessor  :email
end

class EmailValidatorTest < Minitest::Test
  def test_invalidates_object_for_invalid_email
    obj = EmailValidatable.new
    obj.email = "invalidemail"
    refute obj.valid?
  end
end