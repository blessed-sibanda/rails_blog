require "rails_helper"

RSpec.feature "Users can edit their accounts", js: true do
  let(:user) { create :user }

  before { login_as user }

  scenario "successfully" do
    visit root_path

    within(".navbar") do
      click_on "Account"
      click_link "Edit Account"
    end

    expect(page).to have_title "Rails Blog | Edit User"

    expect(user.avatar.attached?).to be_falsy

    fill_in "Name", with: "Blessed Sibanda"
    fill_in "About", with: "I am an awesome person"
    fill_in "Current password", with: "password"
    attach_file "spec/fixtures/image.jpg", class: "avatar-control"

    click_button "Update"

    expect(page).to have_content("Your account has been updated successfully.")

    expect(user.reload.avatar.attached?).to be_truthy
    expect(user.reload.name).to eq "Blessed Sibanda"
    expect(user.reload.about).to eq "I am an awesome person"

    within(".navbar") do
      click_link "Admin"
    end

    expect(page).to have_selector "img.avatar-img"
  end
end
