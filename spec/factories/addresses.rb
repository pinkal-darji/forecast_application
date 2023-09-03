FactoryBot.define do
  factory :address do
    address_line {"Ranip"}
    city { "Ahmedabad" }
    state { "Gujarat" }
    country { "India" }
    zip_code { "382480" }
    user_id { 1 }
  end
end