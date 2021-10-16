require "rails_helper"

RSpec.feature "Users can toggle post status", js: true do
  let!(:user) { create :user }
  let!(:post) { create :post, author: user, status: "Published" }

  before { login_as user }

  scenario "successfully" do
    visit admin_root_path

    within("#post_#{post.id}") do
      expect(page).to have_content post.title
      expect(post.reload.status).to eq "Published"

      expect(page).to have_content "Published"

      within(".post-status") do
        click_link "Unpublish"
      end

      expect(post.reload.status).to eq "Draft"
      expect(page).to_not have_content "Published"
      expect(page).to have_content "Draft"

      within(".post-status") do
        click_link "Publish"
      end

      expect(post.reload.status).to eq "Published"
      expect(page).to_not have_content "Draft"
      expect(page).to have_content "Published"
    end
  end
end
