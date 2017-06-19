FactoryGirl.define do
  factory :gift do
    #id { generate :gift_id }
    name "koloběžka"
    description "dětská"

    trait :associations do
      association :list, factory: :list
    end

    trait :reserved do
      association :donor, factory: :user
    end

  end
end
