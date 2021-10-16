class HomeController < ApplicationController
  def index
    @tags = Post.tag_counts_on :tags
    if params[:tag]
      @posts = Post.published.tagged_with(params[:tag])
        .page(params[:page]).by_date
      @title = "Posts tagged ##{params[:tag]}"
    elsif params[:keywords]
      @posts = Post.published.search(params[:keywords])
        .page(params[:page])
      @title = "Posts matching '#{params[:keywords]}'"
    else
      @posts = Post.published.page(params[:page]).by_date
      @title = "Welcome to the Rails Blog"
    end
  end

  def post
    @post = Post.find_by!(published: params[:date],
                          slug: params[:slug],
                          status: "Published")
    @post.views_count += 1
    @post.save!
  end

  def author_posts
    @author = User.find(params[:id])
    @posts = @author.posts.published.page(params[:page]).by_date
    @title = "Posts by #{@author.name}"
    render :index
  end
end
