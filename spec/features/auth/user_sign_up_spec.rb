require "rails_helper"

RSpec.feature "Users can sign up" do
  scenario "with valid attributes" do
    visit root_url

    within(".navbar") do
      click_link "Register"
    end

    expect(page).to have_title "Rails Blog | Sign up"

    fill_in "Name", with: "Test User"
    fill_in "Email", with: "test@example.com"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"
    click_button "Sign up"

    expect(page).to have_content("You have signed up successfully.")

    expect(User.where(name: "Test User").any?).to be_truthy
  end
end
