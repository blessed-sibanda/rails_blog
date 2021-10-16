require "rails_helper"

RSpec.describe "home/index", type: :view do
  before(:each) do
    create_list(:post, 40)
    Post.published.each do |p|
      p.tag_list.add Faker::Lorem.words.join(",")
      p.save!
    end
    assign(:tags, Post.tag_counts_on(:tags))
    assign(:posts, Post.published.page(1).by_date)
    @title = assign(:title, "Hello there")
    render
  end

  it "renders only the published posts" do
    Post.published.page(1).by_date.each do |p|
      assert_select "#post_#{p.id}" do
        assert_select "h4", p.title
      end
    end

    Post.draft.each do |p|
      expect(rendered).to_not have_selector("#post_#{p.id}")
    end
  end

  it "paginates the posts" do
    pages_count = (Post.published.count / Post.per_page)

    assert_select "nav .pagination" do
      page_num = 2
      while page_num < pages_count
        assert_select "li.page-item" do
          assert_select "a[href=?]", root_path(page: page_num), text: Regexp.new(page_num.to_s)
          page_num += 1
        end
      end
    end
  end

  it "renders title and subtitle" do
    assert_select "h1", "Rails Blog"
    assert_select "p", @title
  end
end
