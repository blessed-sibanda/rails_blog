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
class Post < ApplicationRecord
  include PgSearch::Model

  pg_search_scope :search,
    against: :title,
    associated_against: {
      rich_text_content: [:body],
    },
    using: {
      tsearch: { prefix: true },
    }

  self.per_page = 6
  before_save :keep_last_four_tags

  belongs_to :author, class_name: "User"
  has_rich_text :content
  has_many :comments, as: :commentable

  enum status: {
         "Draft" => 0,
         "Published" => 1,
       }

  validates :status, inclusion: statuses.keys
  validates :title, :content, presence: true
  validates :title,
            uniqueness: { scope: :published,
                          message: "Post title should be unique for given date" }

  acts_as_taggable_on :tags

  scope :published, -> { where(:status => "Published") }
  scope :draft, -> { where(:status => "Draft") }
  scope :by_date, -> { order(created_at: :desc) }
  scope :popular, -> {
      published.where.not(views_count: 0)
        .order(views_count: :desc).limit(10)
    }

  def toggle_status!
    if status == "Draft"
      self.status = "Published"
    else
      self.status = "Draft"
    end
    save!
  end

  def keep_last_four_tags
    self.tag_list = tag_list.last(4)
  end

  def similar_posts
    find_related_tags.published.first(10)
  end

  before_create do
    unless slug
      self.slug = self.title&.parameterize
    end
  end
end
