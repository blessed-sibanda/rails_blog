class CommentsController < ApplicationController
  before_action :set_commentable, only: %i(create)

  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      @post = @comment.parent_post
      ActionCable.server.broadcast \
        "comments",
        { html: render_to_string(@comment.commentable.comments,
                                 layout: false),
          id: @comment.commentable_id,
          commentable: @comment.commentable_type.downcase }
    else
      respond_to do |format|
        format.js
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:name, :email, :content, :commentable_id, :commentable_type)
  end

  def set_commentable
    @commentable = case params[:comment][:commentable_type]
      when "Post"
        Post.published.find(params[:post_id])
      when "Comment"
        Comment.find(params[:comment_id])
      end
  end
end
