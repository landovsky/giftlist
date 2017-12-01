# frozen_string_literal: true

FactoryGirl.define do
  factory :list, traits: [:associations] do
    id { generate :list_id }
    occasion 2 # narozeniny
    occasion_of 'jájenjá'
    occasion_date 2.weeks.from_now

    factory :list_with_guests, parent: :list, traits: [:associations] do
      after(:create) do |list|
        list.invitees << FactoryGirl.create_list(:guest, 2)
        list.gifts    << FactoryGirl.create_list(:gift, 1, list_id: list.id, user_id: list.invitees.last.id)
      end
    end

    trait :associations do
      association :owner, factory: :user
    end

    trait :loose_url do
      association :owner, factory: :user
      after(:create) do |list|
        list.urls << FactoryGirl.create(:url)
      end
    end
  end
end