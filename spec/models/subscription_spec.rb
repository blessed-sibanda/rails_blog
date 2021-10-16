require "rails_helper"

RSpec.describe Subscription, type: :model do
  describe "validations" do
    subject { build(:subscription) }
    it { should validate_uniqueness_of(:user_id).scoped_to(:author_id) }
  end

  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:author).class_name("User") }
  end
end
