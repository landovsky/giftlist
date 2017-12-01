FactoryGirl.define do
  factory :gift do
    #id { generate :gift_id }
    name "koloběžka"
    description "dětská"

    trait :associations do
      association :list, factory: :list
      after(:create) do |gift|
        gift.urls << create(:url)
      end
    end

    trait :reserved do
      association :donor, factory: :user
    end
  end
end
