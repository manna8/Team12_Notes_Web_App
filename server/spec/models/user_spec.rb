require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      user = build(:user)
      expect(user).to be_valid
    end

    it "is not valid without a name" do
      user = build(:user, name: nil)
      expect(user).not_to be_valid
    end

    it "is not valid without an email" do
      user = build(:user, email: nil)
      expect(user).not_to be_valid
    end

    it "is not valid with a duplicate email" do
      user1 = create(:user)
      user2 = build(:user, email: user1.email)
      expect(user2).not_to be_valid
    end

    it "is not valid with an invalid email format" do
      user = build(:user, email: "invalid_email")
      expect(user).not_to be_valid
    end

    it "is not valid without a password" do
      user = build(:user, password: nil)
      expect(user).not_to be_valid
    end

    it "is valid with a password confirmation" do
      user = build(:user, password: "password", password_confirmation: "password")
      expect(user).to be_valid
    end

    it "is not valid with a password confirmation that does not match the password" do
      user = build(:user, password: "password", password_confirmation: "wrong_password")
      expect(user).not_to be_valid
    end


  end


  describe "password encryption" do
    it "encrypts the user's password" do
      user = create(:user, password: "password")
      expect(user.password_digest).not_to eq("password")
    end
  end

end