require "rails_helper"

RSpec.feature "Users can view published posts" do
  scenario "in the home page" do
    create_list :post, 15, :published

    visit "/"

    Post.published.page(1).by_date.each do |p|
      expect(page).to have_content p.title
    end

    within("aside") do
      expect(page).to have_content "Popular Posts"

      Post.popular.each do |p|
        expect(page).to have_content p.title
      end
    end
  end

  scenario "in the post detail page" do
    post = create :post, :published
    post.tag_list = "Love, Life, Food"
    post.save

    post2 = create :post, :published
    post2.tag_list = "Life, People, Religion"
    post2.save!

    post3 = create :post, :published
    post3.tag_list = "Some, Other, Tags"
    post3.save!

    post4 = create :post, :draft
    post4.tag_list = "Love, Food"
    post4.save!

    post5 = create :post, :published
    post5.tag_list = "Life"
    post5.save!

    visit root_path

    within("#post_#{post.id}") do
      click_link post.title
    end

    expect(page.current_path).to eq post_detail_path(post.published, post.slug)
    expect(page).to have_content(post.title)
    expect(page).to have_content(post.author.name)
    expect(page).to have_content(post.content.to_plain_text)
    expect(page).to have_content "1 view"

    within("aside") do
      expect(page).to have_content "Similar Posts"

      # post 2 and post 5 share similar tags with post
      expect(page).to have_content post2.title
      expect(page).to have_content post5.title

      # post 3 does not share any similar tags with post
      expect(page).to_not have_content post3.title

      # post 4 is not published, therefore not returned
      expect(page).to_not have_content post4.title
    end

    visit "/"
    within("#post_#{post.id}") do
      click_link post.title
    end

    expect(page).to have_content "2 views"

    visit "/"
    within("#post_#{post.id}") do
      click_link post.title
    end

    expect(page).to have_content "3 views"

    within("aside") do
      expect(page).to have_content post.author.name
      expect(page).to have_content post.author.about
    end
  end

  context "and filter them" do
    scenario "by author name" do
      user = create :user
      p1 = create(:post, :published)
      p2 = create(:post, :published, author: user)
      p3 = create(:post, :published)
      p4 = create(:post, :published, author: user)
      p5 = create(:post, :draft, author: user)

      visit root_path

      expect(page).to have_content p1.title
      expect(page).to have_content p2.title
      expect(page).to have_content p3.title
      expect(page).to have_content p4.title
      expect(page).to_not have_content p5.title

      click_on user.name, match: :first

      expect(page).to have_content "Posts by #{user.name}"

      expect(page).to_not have_content p1.title
      expect(page).to have_content p2.title
      expect(page).to_not have_content p3.title
      expect(page).to have_content p4.title
      expect(page).to_not have_content p5.title
    end

    scenario "by tag name" do
      p1 = create :post, :published
      p1.tag_list.add "Tag 1", "Tag 2"
      p1.save

      p2 = create :post, :published
      p2.tag_list.add "Tag 2", "Tag 3"
      p2.save

      p3 = create :post, :draft
      p3.tag_list.add "Tag 3", "Tag 1"
      p3.save

      p4 = create :post, :published
      p4.tag_list.add "Tag 4", "Tag 1"
      p4.save

      visit root_path

      click_on "#tag-1", match: :first
      expect(page).to have_content "Posts tagged #tag-1"

      expect(page).to have_content p1.title
      expect(page).to_not have_content p2.title
      expect(page).to_not have_content p3.title
      expect(page).to have_content p4.title
    end
  end
end
