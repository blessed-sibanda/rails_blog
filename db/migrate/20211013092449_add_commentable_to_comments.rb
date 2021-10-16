class AddCommentableToComments < ActiveRecord::Migration[6.1]
  def up
    add_reference :comments, :commentable, polymorphic: true

    Comment.all.each do |comment|
      comment.commentable_id = comment.post_id
      comment.commentable_type = "Post"
      comment.save!
    end

    remove_reference :comments, :post
  end

  def down
    add_reference :comments, :post, null: true, foreign_key: true

    Comment.all.each do |comment|
      comment.post_id = comment.commentable_id if comment.commentable_type == "Post"
      comment.save!
    end

    change_column_null :comments, :post_id, false
    remove_reference :comments, :commentable, polymorphic: true
  end
end
