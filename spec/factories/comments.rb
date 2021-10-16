FactoryBot.define do
  factory :comment do
    name { Faker::Name.name }
    email { name.gsub(/[^A-Za-z0-9]/, "").downcase + "@example.com" }
    content { "This is the comment" }

    association :commentable, factory: :post
  end
end
