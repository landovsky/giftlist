FactoryGirl.define do
  sequence(:user_id)     { |number| 1000 + number }
  sequence(:email)       { |number| "#{(0...20).map { ('a'..'z').to_a[rand(26)] }.join}@aejivheisie.cox" }
  sequence(:list_id)     { |number| 1000 + number }
  sequence(:gift_id)     { |number| 1000 + number }
  sequence(:url_id)      { |number| 1000 + number }
  sequence(:digest)      { |number| (0...20).map { ('a'..'z').to_a[rand(26)] }.join }
end
