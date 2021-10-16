require "rails_helper"

RSpec.feature "Users can search posts" do
  def search_for(term, path = root_path)
    visit path
    fill_in "keywords", with: term
    click_button "Search"
  end

  let!(:p1) do
    create :post, :published, title: "Professional Django", content: "The comprehensive guide"
  end
  let!(:p2) do
    create :post, :published, title: "Comprehensive Rails 6", content: "a complete guide"
  end
  let!(:p3) do
    create :post, :published, title: "Django for Beginners", content: "an excellent django tutorial"
  end

  scenario "successfully" do
    search_for("Django")
    expect(current_path).to eq(root_path)
    expect(page).to have_content "Posts matching 'Django'"
    expect(page).to have_content(p1.title)
    expect(page).not_to have_content(p2.title)
    expect(page).to have_content(p3.title)

    search_for("Rails")
    expect(current_path).to eq(root_path)
    expect(page).to have_content "Posts matching 'Rails'"
    expect(page).not_to have_content(p1.title)
    expect(page).to have_content(p2.title)
    expect(page).not_to have_content(p3.title)

    search_for("djan")
    expect(page).to have_content "Posts matching 'djan'"
    expect(page).to have_content(p1.title)
    expect(page).not_to have_content(p2.title)
    expect(page).to have_content(p3.title)

    search_for("tut")
    expect(page).to have_content "Posts matching 'tut'"
    expect(page).not_to have_content(p1.title)
    expect(page).not_to have_content(p2.title)
    expect(page).to have_content(p3.title)

    search_for("Comprehensive guide")
    expect(page).to have_content "Posts matching 'Comprehensive guide'"
    expect(page).to have_content(p1.title)
    expect(page).to have_content(p2.title)
    expect(page).not_to have_content(p3.title)
  end

  it "searches from any page" do
    search_for("Django", new_user_session_path)
    expect(current_path).to eq(root_path)
    expect(page).to have_content "Posts matching 'Django'"
    expect(page).to have_content(p1.title)
    expect(page).not_to have_content(p2.title)
    expect(page).to have_content(p3.title)
  end
end
