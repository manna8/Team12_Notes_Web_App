require 'rails_helper'

include ActionController::Cookies
RSpec.describe UsersController, type: :controller do

  describe "GET #show" do
    context "when user is authenticated" do
      let(:user) { create(:user, password:  'password') }
      before do

        old_controller = @controller
        @controller = SessionsController.new
        post :create, params: { email: user.email, password:  'password'}
        @controller = old_controller
        end
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
      name = Faker::Name.name
      email = Faker::Internet.email
      let(:password) { Faker::Internet.password }

      it "creates a new user and returns a success message" do
        post :create, params: { name: name, email: email, password: password, password_confirmation: password }

        expect(response).to have_http_status(:created)
        expect(response.body).to eq({ message: "User created successfully." }.to_json)
      end

      it "does not create a new user with the same email address and returns an error message" do
        post :create, params: { name: name, email: email, password: password, password_confirmation: password }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to eq({ errors: ["Name has already been taken","Email has already been taken"]}.to_json)
      end
    end
    context "with invalid parameters" do
      let(:invalid_params) { { name: "", email: "", password: "password", password_confirmation: "wrong_password" } }

      it "returns an error message" do
        post :create, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to eq({ errors: ["Name can't be blank","Email can't be blank","Email is invalid","Password confirmation doesn't match Password"] }.to_json)
      end
    end
  end


  describe "POST #update" do
    context "with valid attributes" do
      let(:user) { create(:user, password:  'password') }
      before do

        old_controller = @controller
        @controller = SessionsController.new
        post :create, params: { email: user.email, password:  'password'}
        @controller = old_controller
      end
      it "updates the user" do
        name = Faker::Name.name
        post :update, params: { id: user.id, name: name }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("User updated successfully.")
        expect(user.reload.name).to eq(name)
      end
      context "with invalid attributes" do
        it "does not update the user" do
          post :update, params: { id: user.id, name: "" }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to include("Name can't be blank")
          expect(user.reload.name).to_not eq("")
        end

    end
  end
    end
  describe "DELETE #destroy" do
    context "when user is authorized" do
      let(:user) { create(:user, password:  'password') }
      before do
        old_controller = @controller
        @controller = SessionsController.new
        post :create, params: { email: user.email, password:  'password'}
        @controller = old_controller
      end
      it "returns the current user's details" do
        expect {
          delete :destroy, params: { id: user.id}
        }.to change(User, :count).by(-1)
        expect(response).to have_http_status(:ok)
      end

    end

    end

    describe "GET #all_users" do
      context "when admin is authenticated" do
        let(:admin) { create(:user, role:  'admin', password: "password") }
        before do
          old_controller = @controller
          @controller = SessionsController.new
          post :create, params: { email: admin.email, password:  "password"}
          @controller = old_controller
        end

        it "returns all users' information" do
          get :all_users
          expect(response).to have_http_status(:ok)
          expect(response.body).to include(User.all.to_json)
        end
      end
    end
  end

