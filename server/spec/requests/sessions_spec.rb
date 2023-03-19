require 'rails_helper'
include ActionController::Cookies

RSpec.describe "Sessions", type: :request do
  describe "#create" do
    let(:user) { FactoryBot.create(:user, password: "password") }

    context "with valid credentials" do
      it "logs in successfully and sets jwt cookie" do
        post "/login", params: { email: user.email, password: "password" }
        expect(response).to have_http_status(:ok)
        puts cookies[:jwt]
        expect(response.cookies[:jwt]).to_not be_nil
      end
    end

    context "with invalid credentials" do
      it "returns unauthorized" do
        post "/login", params: { email: user.email, password: "wrongpassword" }
        expect(response).to have_http_status(:unauthorized)
        expect(cookies[:jwt]).to be_nil
      end
    end
  end

  describe "#show" do
    context "when user is authenticated" do
      let(:user) { FactoryBot.create(:user) }
      before { post "/login", params: { email: user.email, password: user.password } }

      it "returns the current user" do
        get "/login"
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq(user.to_json)
      end
    end

    context "when user is not authenticated" do
      it "returns unauthorized" do
        get "/login"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "#destroy" do
    let(:user) { create(:user) }
    before { post "/login", params: { email: user.email, password: user.password } }

    it "logs out the user" do
      delete "/logout"
      expect(response).to have_http_status(:ok)
      expect(cookies[:jwt]).to be_nil
    end
  end
end