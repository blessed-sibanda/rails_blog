require "rails_helper"

RSpec.feature "Users can sign out" do
  let(:user) { create :user }

  before { login_as user }

  scenario "sucessfully" do
    visit root_url

    within(".navbar .dropdown-menu") do
      click_link "Log out"
    end

    expect(page).to have_content("Signed out successfully.")
    expect(page.current_path).to eq root_path
  end
end
