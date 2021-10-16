FactoryBot.define do
  factory :subscription do
    association :user, strategy: :build
    association :author, factory: :user, strategy: :build
  end
end
