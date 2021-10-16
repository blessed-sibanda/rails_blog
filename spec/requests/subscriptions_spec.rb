require "rails_helper"

RSpec.describe "Subscriptions", type: :request do
  describe "PATCH /id" do
    let(:user) { create :user }
    let(:author) { create :user }

    it "creates a subscription" do
      login_as user
      expect(author.reload.subscribers.count).to eq 0
      patch subscription_path(id: author.id), xhr: true
      expect(author.reload.subscribers.count).to eq 1
      expect(author.reload.subscribers).to include(user)
    end
  end
end
