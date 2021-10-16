class ChangePostsPublishedToDate < ActiveRecord::Migration[6.1]
  def up
    change_column :posts, :published, :date, null: false, default: Date.today
  end

  def down
    change_column :posts, :published, :datetime, null: false, default: Time.zone.now
  end
end
