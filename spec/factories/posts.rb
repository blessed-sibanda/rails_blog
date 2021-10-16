FactoryBot.define do
  factory :post do
    sequence(:title) { |n| "Post #{n}" }
    content { "This is the post content" }
    association :author, factory: :user, strategy: :build
    status { Post.statuses.keys.sample }

    trait :published do
      status { "Published" }
    end

    trait :draft do
      status { "Draft" }
    end
  end
end
