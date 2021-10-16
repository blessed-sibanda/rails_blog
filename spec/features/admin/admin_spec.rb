require "rails_helper"

RSpec.feature "Users can view admin page" do
  scenario "successfully" do
    user = create :user, about: "I am awesome"
    create_list :post, 10, author: user

    # posts by other users
    create_list :post, 10
    login_as user

    visit admin_root_path

    # check that only the user's posts are displayed
    Post.where.not(author_id: user.id).each do |p|
      expect(page).to_not have_content(p.title)
    end

    Post.where(author_id: user.id).each do |p|
      expect(page).to have_content(p.title)
    end

    within("aside") do
      expect(page).to have_content user.name
      expect(page).to have_content user.about
    end
  end
end
