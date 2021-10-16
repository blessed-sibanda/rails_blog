require "rails_helper"

RSpec.feature "Users can comment on posts", js: true do
  let!(:post1) { create :post, :published }

  def create_comment
    fill_in "Name", with: "John Doe"
    fill_in "Email", with: "johndoe@example.com"

    fill_in "Content", with: "Very nice post"
    click_on "Create Comment"
  end

  scenario "successfully" do
    visit "/"
    click_on post1.title

    within(".comment-form") do
      create_comment
    end

    expect(page).to have_content "John Doe"
    expect(page).to have_content "Very nice post"
  end

  scenario "and also on other comments" do
    comment = create(:comment, commentable: post1)

    visit "/"
    click_on post1.title

    within("#comment_#{comment.id}") do
      click_on "Reply"

      create_comment

      expect(page).to have_content "John Doe"
      expect(page).to have_content "Very nice post"
    end
  end
end
