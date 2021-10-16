require "rails_helper"

RSpec.feature "Users can create posts", js: true do
  let(:user) { create :user }
  before { login_as user }

  scenario "sucessfully" do
    visit root_path

    within(".navbar") do
      click_link "Admin"
    end

    click_link "New Post"

    fill_in "Title", with: "Why Rails is so awesome"
    find("trix-editor").set("Because of blah blah and blah")
    select "Published", from: "Status"
    fill_in "post[tag_list]", with: "Rails, Web Development"

    click_button "Create Post"

    expect(page).to have_content("Post has been created.")
    expect(page.current_path).to eq admin_root_path

    within(".post-item") do
      expect(page).to have_content "Why Rails is so awesome"
      expect(page).to have_content "Published"
    end

    within(".tags") do
      expect(page).to have_content "rails"
      expect(page).to have_content "web-development"
    end

    click_link "Preview"

    p = Post.last
    expect(page.current_path).to eq admin_post_path(p)
    expect(page).to have_content "Post Preview"
  end
end
