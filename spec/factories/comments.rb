# == Schema Information
#
# Table name: comments
#
#  id               :bigint           not null, primary key
#  commentable_type :string
#  content          :text
#  email            :string
#  name             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  commentable_id   :bigint
#
# Indexes
#
#  index_comments_on_commentable  (commentable_type,commentable_id)
#
FactoryBot.define do
  factory :comment do
    name { Faker::Name.name }
    email { name.gsub(/[^A-Za-z0-9]/, "").downcase + "@example.com" }
    content { "This is the comment" }

    association :commentable, factory: :post
  end
end
