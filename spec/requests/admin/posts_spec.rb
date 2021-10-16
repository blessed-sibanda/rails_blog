require "rails_helper"

RSpec.describe "Admin::Posts", type: :request do
  let(:valid_attributes) {
    { title: "My Post",
      content: "Post content",
      status: "Published",
      tag_list: "Tag 1, Tag 2" }
  }

  let(:invalid_attributes) {
    { title: "",
      content: "",
      status: "Draft",
      tag_list: "" }
  }

  describe "GET /admin/posts/new" do
    context "authenticated user" do
      before { login_as create(:user) }

      it "returns http success" do
        get "/admin/posts/new"
        expect(response).to have_http_status(:success)
      end
    end

    context "unauthenticated user" do
      it "redirects away" do
        get "/admin/posts/new"
        expect(response).to have_http_status(302)
      end
    end
  end

  describe "GET /admin/posts/:id" do
    let(:post) { create :post }
    context "authenticated user" do
      it "returns http success when user is post author" do
        login_as post.author
        get admin_post_path(post)
        expect(response).to have_http_status(:success)
      end

      it "redirects away when user is not post author" do
        login_as create(:user)
        get admin_post_path(post)
        expect(response).to have_http_status(302)
      end
    end

    context "unauthenticated user" do
      it "redirects away" do
        get admin_post_path(post)
        expect(response).to have_http_status(302)
      end
    end
  end

  describe "PATCH /admin/posts/:id/toggle_status" do
    let!(:post) { create :post, :draft }
    context "authenticated user" do
      context "when user is the post author" do
        before { login_as post.author }

        it "toggles the post status" do
          expect(post.reload.status).to eq "Draft"
          patch toggle_status_admin_post_path(post), xhr: true
          expect(post.reload.status).to eq "Published"
          patch toggle_status_admin_post_path(post), xhr: true
          expect(post.reload.status).to eq "Draft"
        end

        it "returns http success" do
          patch toggle_status_admin_post_path(post), xhr: true
          expect(response).to have_http_status(:success)
        end
      end

      context "when user is not post author" do
        before { login_as create(:user) }
        it "does not change the post status" do
          expect(post.status).to eq "Draft"
          patch toggle_status_admin_post_path(post), xhr: true
          expect(post.status).to eq "Draft"
        end
      end
    end

    context "unauthenticated user" do
      it "returns unauthorized" do
        expect(post.reload.status).to eq "Draft"
        patch toggle_status_admin_post_path(post), xhr: true
        expect(post.reload.status).to eq "Draft"
        expect(response).to have_http_status(401)
      end
    end
  end

  describe "DELETE /admin/posts/:id/remove_tag" do
    let!(:post) { create :post }

    before do
      post.tag_list = "Life, People, Love"
      post.save!
    end

    context "authenticated user" do
      it "removes the tag if user is the post author" do
        login_as post.author
        expect(post.reload.tag_list).to eq ["life", "people", "love"]
        tag = ActsAsTaggableOn::Tag.find_by(name: "life")
        delete remove_tag_admin_post_path(post, tag_id: tag.id), xhr: true
        expect(post.reload.tag_list).to eq ["people", "love"]
        expect(response).to have_http_status(:success)
      end

      it "does not remove the tag if user is not the post author" do
        login_as create(:user)
        expect(post.reload.tag_list).to eq ["life", "people", "love"]
        tag = ActsAsTaggableOn::Tag.find_by(name: "life")
        delete remove_tag_admin_post_path(post, tag_id: tag.id), xhr: true
        expect(post.reload.tag_list).to eq ["life", "people", "love"]
      end
    end

    context "unauthenticated user" do
      it "returns unauthorized" do
        expect(post.reload.tag_list).to eq ["life", "people", "love"]
        tag = ActsAsTaggableOn::Tag.find_by(name: "life")
        delete remove_tag_admin_post_path(post, tag_id: tag.id), xhr: true
        expect(post.reload.tag_list).to eq ["life", "people", "love"]
        expect(response).to have_http_status(401)
      end
    end
  end

  describe "POST /admin/posts" do
    context "authenticated user" do
      before { login_as create(:user) }
      context "when valid parameters are given" do
        it "creates a new Post" do
          expect {
            post admin_posts_path, params: { post: valid_attributes }
          }.to change(Post, :count).by(1)
        end

        it "only keeps a max of 4 tags when more tags are provided" do
          post admin_posts_path, params: { post: {
                              title: "Post #{SecureRandom.hex(4)}",
                              content: "This is the post content",
                              status: "Draft",
                              tag_list: "Rails, Ruby, Web, Programming, Agile, RSpec",
                            } }
          created_post = Post.last
          expect(created_post.tag_list).to eq(["web", "programming", "agile", "rspec"])
        end

        it "redirects to admin_root_url" do
          post admin_posts_path, params: { post: valid_attributes }
          expect(response).to redirect_to(admin_root_url)
        end
      end

      context "when invalid parameters are given" do
        it "creates a new Post" do
          expect {
            post admin_posts_path, params: { post: invalid_attributes }
          }.to_not change(Post, :count)
        end

        it "re-renders the page" do
          post admin_posts_path, params: { post: invalid_attributes }
          expect(response).to be_successful
        end
      end
    end

    context "unauthenticated user" do
      it "redirects away" do
        post admin_posts_path, params: { post: valid_attributes }
        expect(response).to have_http_status(302)
      end
    end
  end

  describe "GET /admin/posts/:id/edit" do
    let(:post) { create :post }
    context "authenticated user" do
      context "when user is post author" do
        it "renders successfully" do
          login_as post.author
          get edit_admin_post_path(post)
          expect(response).to be_successful
        end
      end

      context "when user is not post author" do
        it "redirects away" do
          login_as create(:user)
          get edit_admin_post_path(post)
          expect(response).to redirect_to admin_root_path
        end
      end
    end

    context "unauthenticated user" do
      it "redirects away" do
        get edit_admin_post_url(post)
        expect(response).to have_http_status(302)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "PATCH /admin/posts/:id" do
    let(:post) { create :post }
    let(:new_attributes) do
      { title: "Updated Post",
        content: "Post content",
        status: "Published",
        tag_list: "Tag 1, Tag X" }
    end

    context "when user is authenticated" do
      context "when user is post author" do
        before { login_as post.author }

        context "when valid attributes are given" do
          it "updates the post" do
            old_title = post.title
            patch admin_post_url(post), params: { post: new_attributes }
            post.reload
            expect(post.title).to_not eq(old_title)
            expect(post.title).to eq("Updated Post")
          end

          it "returns redirects to admin_root" do
            patch admin_post_url(post), params: { post: new_attributes }
            expect(response).to redirect_to admin_root_url
          end
        end

        context "when invalid attributes are given" do
          it "does not update the post" do
            old_title = post.title
            patch admin_post_url(post), params: { post: invalid_attributes }
            post.reload
            expect(post.title).to eq(old_title)
          end

          it "re-renders the form" do
            patch admin_post_url(post), params: { post: invalid_attributes }
            expect(response).to have_http_status(:success)
          end
        end
      end

      context "when user is not post author" do
        it "redirects away" do
          login_as create(:user)
          patch admin_post_url(post), params: { post: valid_attributes }
          expect(response).to have_http_status(302)
        end
      end
    end

    context "when user is unauthenticated" do
      it "redirects away" do
        patch admin_post_url(post), params: { post: valid_attributes }
        expect(response).to have_http_status(302)
      end
    end
  end

  describe "DELETE /admin/posts/:id" do
    let!(:post) { create :post }

    context "when user is authenticated" do
      context "when user is post author" do
        before { login_as post.author }
        it "deletes the post" do
          expect {
            delete admin_post_url(post)
          }.to change(Post, :count).by(-1)
        end

        it "redirects to admin_root" do
          delete admin_post_url(post)
          expect(response).to redirect_to admin_root_url
        end
      end

      context "when user is not post author" do
        before { login_as create(:user) }

        it "redirects away" do
          delete admin_post_url(post)
          expect(response).to have_http_status(302)
        end

        it 'doesn\'t delete the post' do
          expect {
            delete admin_post_url(post)
          }.to_not change(Post, :count)
        end
      end
    end
  end
end
