# == Schema Information
#
# Table name: subscriptions
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  author_id  :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_subscriptions_on_author_id              (author_id)
#  index_subscriptions_on_author_id_and_user_id  (author_id,user_id) UNIQUE
#  index_subscriptions_on_user_id                (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (author_id => users.id)
#  fk_rails_...  (user_id => users.id)
#
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
