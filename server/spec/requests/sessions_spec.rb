# require 'rails_helper'
# include ActionController::Cookies
#
# RSpec.describe "Sessions", type: :request do
#   describe "#create" do
#     let(:user) { FactoryBot.create(:user, password: "password") }
#
#     context "with valid credentials" do
#       it "logs in successfully and sets jwt cookie" do
#         post "/login", params: { email: user.email, password: "password" }
#         expect(response).to have_http_status(:ok)
#         puts cookies[:jwt]
#         expect(response.cookies[:jwt]).to_not be_nil
#       end
#     end
#
#     context "with invalid credentials" do
#       it "returns unauthorized" do
#         post "/login", params: { email: user.email, password: "wrongpassword" }
#         expect(response).to have_http_status(:unauthorized)
#         expect(cookies[:jwt]).to be_nil
#       end
#     end
#   end
#
#   describe "#show" do
#     context "when user is authenticated" do
#       let(:user) { FactoryBot.create(:user) }
#       before { post "/login", params: { email: user.email, password: user.password } }
#
#       it "returns the current user" do
#         get "/login"
#         expect(response).to have_http_status(:ok)
#         expect(response.body).to eq(user.to_json)
#       end
#     end
#
#     context "when user is not authenticated" do
#       it "returns unauthorized" do
#         get "/login"
#         expect(response).to have_http_status(:unauthorized)
#       end
#     end
#   end
#
#   describe "#destroy" do
#     let(:user) { create(:user) }
#     before { post "/login", params: { email: user.email, password: user.password } }
#
#     it "logs out the user" do
#       delete "/logout"
#       expect(response).to have_http_status(:ok)
#       expect(cookies[:jwt]).to be_nil
#     end
#   end
# end

require 'rails_helper'

include ActionController::Cookies

# include ApplicationController
RSpec.describe SessionsController, type: :controller do


  describe "POST create" do
    context "with valid email and password" do
      let(:user) { create(:user, password: 'password' ) }

      it "returns a success message and sets the JWT cookie" do
        post :create, params: { email: user.email, password: 'password' }

        expect(response).to have_http_status(:ok)
        expect(cookies['jwt']).to_not be_nil

      end
    end

    context "with invalid password" do
      let(:user) { create(:user, password: 'password' ) }
      it "returns an unauthorized message" do
        post :create, params: { email: user.email, password: 'wrongpassword' }
        expect(response).to have_http_status(:unauthorized)
        expect(cookies['jwt']).to be_nil
      end
    end
    context "with invalid password" do
      let(:user) { create(:user, password: 'password') }
      it "returns an unauthorized message" do
        post :create, params: { email: 'wrong@mail', password: 'password' }
        expect(response).to have_http_status(:unauthorized)
        expect(cookies['jwt']).to be_nil
      end
    end
  end

  describe "GET show" do
    context "when user is authenticated" do
      let(:user) { create(:user, password: 'password') }

      it "returns the current user's information" do

        post :create, params: { email: user.email, password: 'password' }

        get :show
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['email']).to eq(user.email)
      end
    end

    context "when user is not authenticated" do
      it "returns an unauthorized message" do
        get :show
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "DELETE destroy" do
    context "when user is authenticated" do
      let(:user) { create(:user, password: 'password') }

      it "deletes the JWT cookie and logs out the user" do
        post :create, params: { email: user.email, password: 'password' }
        delete :destroy
        expect(response).to have_http_status(:ok)
        expect(response.cookies['jwt']).to be_nil
      end
    end

    context "when user is not authenticated" do
      it "returns an unauthorized message" do
        delete :destroy
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
