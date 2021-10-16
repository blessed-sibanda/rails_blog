require "rails_helper"

RSpec.feature "Users can subscribe to authors", js: true do
  scenario "successfully" do
    user = create :user
    author = create :user
    post = create :post, :published, author: author

    visit "/"

    click_link post.title

    within("aside") do
      expect(page).to have_content "Login to subscribe to this author"
    end

    login_as user

    click_link post.title

    within("aside") do
      expect(page).to_not have_content "Login to subscribe to this author"
      click_link "Subscribe to this author's posts"
      expect(page).to have_content "You have successfully subscribed to this author"
    end

    expect(author.reload.subscribers.count).to eq 1
    expect(author.reload.subscribers).to include(user)

    visit "/"
    click_link post.title, match: :first

    within("aside") do
      expect(page).to_not have_content "Login to subscribe to this author"
      expect(page).to_not have_content "Subscribe to this author's posts"
      expect(page).to_not have_content "You have successfully subscribed to this author"
    end
  end
end
