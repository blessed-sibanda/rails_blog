require "rails_helper"

RSpec.describe "Admin::Application", type: :request do
  describe "GET" do
    context "authenticated user" do
      before { login_as create(:user) }

      it "returns http success" do
        get "/admin"
        expect(response).to have_http_status(:success)
      end
    end

    context "unauthenticated user" do
      it "redirects away" do
        get "/admin"
        expect(response).to have_http_status(302)
      end
    end
  end
end
