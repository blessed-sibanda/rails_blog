# == Schema Information
#
# Table name: posts
#
#  id          :bigint           not null, primary key
#  published   :date             default(Fri, 09 Sep 2022), not null
#  slug        :string           not null
#  status      :integer          default("Draft"), not null
#  title       :string           not null
#  views_count :bigint           default(0)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  author_id   :bigint           not null
#
# Indexes
#
#  index_posts_on_author_id           (author_id)
#  index_posts_on_slug_and_published  (slug,published) UNIQUE
#  index_posts_on_views_count         (views_count)
#
# Foreign Keys
#
#  fk_rails_...  (author_id => users.id)
#
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
