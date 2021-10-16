class Subscription < ApplicationRecord
  belongs_to :author, class_name: "User"
  belongs_to :user

  validates_uniqueness_of :user_id, scope: :author_id
end
