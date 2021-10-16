require "rails_helper"

RSpec.feature "Users can reset their passwords" do
  let(:user) { create :user }

  scenario "if they are registered" do
    visit root_url

    within(".navbar") do
      click_link "Login"
    end

    click_link "Forgot your password?"

    expect(page).to have_title "Rails Blog | Forgot your password"

    fill_in "Email", with: user.email
    click_button "Send me reset password instructions"

    message = "You will receive an email with instructions on how to reset your password in a few minutes."
    expect(page).to have_content message

    expect(page.current_path).to eq(new_user_session_path)

    email = find_email!(user.email)
    click_email_link_matching(/password\/edit/, email)
    expect(current_path).to eq edit_user_password_path

    fill_in "Password", with: "new-password"
    fill_in "Password confirmation", with: "new-password"
    click_button "Change my password"

    message = "Your password has been changed successfully. You are now signed in."
    expect(page).to have_content message

    expect(current_path).to eq root_path
  end
end
