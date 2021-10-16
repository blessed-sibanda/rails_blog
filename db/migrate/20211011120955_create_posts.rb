class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.references :author, null: false, foreign_key: { to_table: :users }
      t.integer :status, null: false, default: 0
      t.datetime :published, null: false, default: Time.zone.now

      t.timestamps
    end

    add_index :posts, %i(slug published), unique: true
  end
end
