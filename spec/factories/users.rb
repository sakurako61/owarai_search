FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
    password { "password8" }
    password_confirmation { "password8" }
  end
end
