require "rails_helper"

RSpec.describe User, type: :model do
  describe "associations" do
    it { should have_many(:posts).with_foreign_key("author_id") }
    it { should have_many(:subscriptions).with_foreign_key("author_id") }
    it { should have_many(:subscribers).through(:subscriptions).source(:user) }
  end

  describe "#subscribed_to?" do
    it "returns true if user is subscribed to author" do
      u = create :user
      author = create :user

      Subscription.create(author: author, user: u)
      expect(u.reload.subscribed_to?(author)).to be_truthy
      expect(author.reload.subscribed_to?(u)).to be_falsy
    end
  end
end
