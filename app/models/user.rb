class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, foreign_key: "author_id"
  has_one_attached :avatar
  has_many :subscriptions, foreign_key: "author_id"
  has_many :subscribers, through: :subscriptions, source: :user

  def subscribed_to?(author)
    author.subscribers.include?(self)
  end
end
