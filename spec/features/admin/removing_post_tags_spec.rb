require "rails_helper"

RSpec.feature "Users can remove post tags", js: true do
  let!(:user) { create :user }
  let!(:post) { create :post, author: user }
  let!(:tag) { ActsAsTaggableOn::Tag.create(name: "Tag 1") }

  before do
    login_as user
    post.tags << tag
  end

  scenario "sucessfully" do
    expect(post.reload.tags).to include(tag)

    visit admin_root_path

    within(".post-item") do
      expect(page).to have_content post.title
      expect(page).to have_content "Tag 1"
      find(".tags .tag a.remove-tag").click
      expect(post.reload.tags).to_not include(tag)
      expect(page).to_not have_content "Tag 1"
    end
  end
end
