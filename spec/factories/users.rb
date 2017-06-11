FactoryGirl.define do
  factory :user do
    id { generate :user_id }
    name     "John"
    surname  "Doe"
    role     2
    email    { generate :email }
    password "něco"
  end

  factory :guest, class: User do
    id      { generate :user_id }
    name    "Paul"
    surname "Guest"
    role    0
    email   { generate :email }
    password "něco"
  end

  factory :user_with_list, parent: :user do
    after(:create) { |user| create(:list_with_guests, user_id: user.id )}
  end

end
