# frozen_string_literal: true

FactoryGirl.define do
  factory :url do
    id        { generate :url_id }
    digest    { generate :digest }
    data({ :url=>"http://localhost:3000/test_product",
           :favicon=>"",
           :title=>"testovací produkt",
           :description=>"",
           :images=>[{:src=>"http://localhost:3000/assets/givit-a660260307c7f8251191ebce8aa3ae5f03252fc4e04e8b0b3a9ccddd1a257ee0.png", :size=>[], :type=>nil}],
           :videos=>[]}
        )
  end
end
