require "rails_helper"

RSpec.feature "Users can delete posts", js: true do
  let!(:post) { create :post }

  before { login_as post.author }

  scenario "sucessfully" do
    visit admin_root_path

    within(".post-item") do
      expect(page).to have_content(post.title)
      accept_confirm do
        click_link "Delete"
      end
    end

    expect(page).to have_content("Post has been deleted.")
    expect(page.current_path).to eq admin_root_path

    expect(page).not_to have_content(post.title)
  end
end
