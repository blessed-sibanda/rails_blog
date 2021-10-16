class CreateSubscriptions < ActiveRecord::Migration[6.1]
  def change
    create_table :subscriptions do |t|
      t.references :author, null: false, foreign_key: { to_table: :users }
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :subscriptions, %i(author_id user_id), unique: true
  end
end
