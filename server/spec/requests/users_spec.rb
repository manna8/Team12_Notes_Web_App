require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /index" do
    it "contains users" do
      get "/users/get"
      expect(response).to include user.name
      end
    #pending "add some examples (or delete) #{__FILE__}"
  end
end
