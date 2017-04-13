class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    email = value
    record.errors[:email] << (options[:message] || "Takhle emailová adresa nevypadá... Zkusíš to ještě jednou?") if !EmailChecker.new(email).valid?
  end
end