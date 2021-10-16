require "rails_helper"

RSpec.feature "Users can edit posts", js: true do
  let!(:post) { create :post }

  before { login_as post.author }

  scenario "sucessfully" do
    post.tag_list.add ["Tag 1", "Tag 2"]
    post.save

    visit admin_root_path

    within(".post-item") do
      click_link "Edit"
    end

    fill_in "Title", with: "New Updated Title"
    fill_in "post[tag_list]", with: "Ruby, Rails, Programming"

    within(".tags") do
      expect(page).to have_content "tag-1"
      expect(page).to have_content "tag-2"
      tag = ActsAsTaggableOn::Tag.find_by(name: "tag-1")
      find("#acts_as_taggable_on_tag_#{tag.id} > a.remove-tag").click
    end

    click_button "Update Post"

    expect(page).to have_content("Post has been updated.")
    expect(page.current_path).to eq admin_root_path

    expect(page).to have_content "New Updated Title"

    within(".tags") do
      expect(page).to_not have_content "tag-1"
      expect(page).to have_content "tag-2"
      expect(page).to have_content "ruby"
      expect(page).to have_content "rails"
      expect(page).to have_content "programming"
    end
  end
end
