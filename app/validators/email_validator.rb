class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    email = value
    record.errors[:email] << (options[:message] || "Zadaná hodnota není validní emailová adresa.") if !EmailChecker.new(email).valid?
  end
end