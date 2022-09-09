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
class Comment < ApplicationRecord
  validates :name, :email, :content, presence: true
  validates :content, length: { minimum: 10 }
  validates_format_of :email,
                      with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/

  belongs_to :commentable, polymorphic: true
  has_many :comments, as: :commentable

  def parent_post
    loop do
      c = commentable
      return c if c.class == Post
      self.commentable = c.commentable
    end
  end
end
