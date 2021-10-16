FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { "users-#{SecureRandom.hex(3)}@example.com" }
    password { "password" }
    about { "" }
  end
end
