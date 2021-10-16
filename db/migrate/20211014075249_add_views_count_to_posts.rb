class AddViewsCountToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :views_count, :bigint, default: 0
    add_index :posts, :views_count
  end
end
