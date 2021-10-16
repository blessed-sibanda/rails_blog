require "rails_helper"

RSpec.describe Post, type: :model do
  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:content) }
    it { should allow_value("Draft").for(:status) }
    it { should allow_value("Published").for(:status) }
  end

  describe "associations" do
    it { should belong_to(:author).class_name("User") }
    it { should have_many(:tags).class_name("ActsAsTaggableOn::Tag") }
    it { should have_many(:comments) }
    it { should have_rich_text(:content) }
  end

  it "ensures unique post titles for the same published date" do
    p1 = create(:post, title: "Post 1")
    p2 = build(:post, title: "Post 1")
    p3 = build(:post, title: "Post 1", published: 1.day.from_now)

    expect(p2).to be_invalid
    expect(p3).to be_valid
  end

  describe "#similar_posts" do
    it "returns at most 10 published posts" do
      create_list :post, 30, :published

      Post.all.each do |p|
        p.tag_list = "Tag 1, Tag 2"
        p.save!
      end

      post = Post.first

      expect(post.similar_posts.length).to eq 10
    end
  end
end
