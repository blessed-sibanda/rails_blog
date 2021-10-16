require "rails_helper"

RSpec.describe "home/post", type: :view do
  before(:each) do
    @post = assign(:post, create(:post))
    assign(:comment, @post.comments.build)

    render
  end

  it "renders the post details" do
    assert_select "h1", text: @post.title
    expect(rendered).to have_content @post.content.to_plain_text
    expect(rendered).to have_content @post.created_at.to_s(:long)
    expect(rendered).to have_content @post.author.name
  end

  it "renders new comment form" do
    assert_select "form[action=?][method=?]", post_comments_path(@post), "post" do
      assert_select "input[name=?]", "comment[name]"
      assert_select "input[name=?]", "comment[email]"

      expect(rendered).to have_content "Your email address will not be published."
      assert_select "textarea[name=?]", "comment[content]"
    end
  end
end
