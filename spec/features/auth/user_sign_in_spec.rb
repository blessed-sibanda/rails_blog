require "rails_helper"

RSpec.feature "Users can sign in" do
  let(:user) { create :user }
  scenario "with valid credentials" do
    visit root_url

    within(".navbar") do
      click_link "Login"
    end

    expect(page).to have_title "Rails Blog | Log in"

    fill_in "Email", with: user.email
    fill_in "Password", with: "password"
    click_button "Log in"

    expect(page).to have_content "Signed in successfully."
  end
end
