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
