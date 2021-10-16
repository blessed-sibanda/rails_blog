require "rails_helper"

RSpec.describe "Comments", type: :request do
  let(:blog_post) { create :post }
  let(:valid_attributes) do
    {
      name: "John Doe",
      email: "johndoe@example.com",
      content: "Very nice post",
      commentable_id: blog_post.id,
      commentable_type: "Post",
    }
  end

  let(:invalid_attributes) do
    {
      name: "",
      email: "ample.com",
      content: "Very",
      commentable_id: blog_post.id,
      commentable_type: "Post",
    }
  end

  describe "POST /" do
    let!(:blog_post) { create(:post, :published) }

    context "when valid attributes are given" do
      it "creates a new comment" do
        expect {
          post post_comments_url(blog_post),
               params: { comment: valid_attributes }, xhr: true
        }.to change(Comment, :count).by(1)
      end
    end

    context "when invalid attributes are given" do
      it "does not create a new comment" do
        expect {
          post post_comments_url(blog_post),
               params: { comment: invalid_attributes }, xhr: true
        }.to_not change(Comment, :count)
      end

      it "re-renders the form" do
        post post_comments_url(blog_post),
             params: { comment: invalid_attributes }, xhr: true
        expect(response).to have_http_status(200)
      end
    end
  end
end
