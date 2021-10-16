class Admin::PostsController < Admin::ApplicationController
  before_action :set_post, except: %i[new create]

  def new
    @post = Post.new
  end

  def show
  end

  def toggle_status
    @post.toggle_status!
    respond_to do |format|
      format.js
    end
  end

  def remove_tag
    tag = ActsAsTaggableOn::Tag.find(params[:tag_id])
    @tag_id = tag.id
    @post.tag_list.remove(tag.name)
    @post.save!
    head :ok
  end

  def create
    @post = Post.new(post_params)
    @post.author = current_user
    @post.tag_list = processed_tags
    if @post.save
      flash[:notice] = "Post has been created."
      redirect_to admin_root_path
    else
      flash[:alert] = "Post has not been created."
      render :new
    end
  end

  def update
    @post.tag_list << processed_tags
    if @post.update(post_params)
      flash[:notice] = "Post has been updated."
      redirect_to admin_root_path
    else
      flash[:alert] = "Post has not been updated."
      render :edit
    end
  end

  def destroy
    @post.destroy
    flash[:notice] = "Post has been deleted."
    redirect_to admin_root_path
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :status)
  end

  def processed_tags
    params[:post][:tag_list].split(",")
  end

  def set_post
    @post = Post.find(params[:id])

    unless current_user == @post.author
      flash[:notice] = "Only post author is allowed to perform this action"
      redirect_to admin_root_path
    end
  end
end
