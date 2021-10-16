module ApplicationHelper
  def render_tags(post)
    render "admin/posts/tags", post: post
  end

  def author_page(post)
    author_path(post.author_id, post.author.name.parameterize)
  end

  def render_user_profile(user = current_user, &block)
    render "users/user", user: user, &block
  end
end
