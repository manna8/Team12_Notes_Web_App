require 'rails_helper'

# RSpec.describe "Users", type: :request do
#   describe "GET /index" do
#     it "contains users" do
#       get "/users/get"
#       expect(response).to include user.name
#       end
#     #pending "add some examples (or delete) #{__FILE__}"
#   end
# end
include ActionController::Cookies
RSpec.describe UsersController, type: :controller do
  describe "GET #show" do
    context "when user is authenticated" do
      let(:user) { create(:user) }

      it "returns the current user's details" do
        get :show
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq({ user: user }.to_json)
      end
    end

    context "when user is not authenticated" do
      it "returns unauthorized status" do
        get :show
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      let(:valid_params) do
        attributes_for(:user, name: Faker::Name.name, email: Faker::Internet.email, password: "password",  password_confirmation: "password")
      end

      it "creates a new user and returns a success message" do
        post :create, params: { user: valid_params }
        expect(response).to have_http_status(:created)
        expect(response.body).to eq({ message: "User created successfully." }.to_json)
        expect(User.last.name).to eq(valid_params[:name])
        expect(User.last.email).to eq(valid_params[:email])
      end

      it "sets the JWT cookie" do
        post :create, params: { user: valid_params }
        expect(cookies["jwt"]).not_to be_nil
      end
    end
  end

    context "with invalid parameters" do
      let(:invalid_params) { { name: "", email: "", password: "password", password_confirmation: "wrong_password" } }

      it "returns an error message" do
        post :create, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to eq({ errors: ["Name can't be blank","Email can't be blank","Email is invalid","Password confirmation doesn't match Password"] }.to_json)
      end

      it "does not create a new user" do
        expect {
          post :create, params: invalid_params
        }.not_to change(User, :count)
      end

      it "does not set the JWT cookie" do
        post :create, params: invalid_params
        expect(cookies["jwt"]).to be_nil
      end
    end
  end

