FactoryGirl.define do
  sequence(:user_id)     { |number| 1000 + number }
  sequence(:email)       { |number| "neco#{number}@aejivheisie.cox" }
  sequence(:list_id)     { |number| 1000 + number }
  sequence(:gift_id)     { |number| 1000 + number }
end
