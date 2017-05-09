class OccasionDataValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    occasion_data = value
    Rails.logger.debug "_______#{self}: #{__method__}: record: #{record}"
    Rails.logger.debug "_______#{self}: #{__method__}: attribute: #{attribute}"
    Rails.logger.debug "_______#{self}: #{__method__}: value: #{value} / #{value.class}"
    occasion_data.each do |key,val|
      case key
      when "other"
        record.errors[:occasion_data]["other"] << (options[:message] || "Rozepiš se.") if val.blank?
      end
    end
  end
end