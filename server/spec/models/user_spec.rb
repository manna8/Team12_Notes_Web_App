require 'rails_helper'

# RSpec.describe User, type: :model do
#   it 'ensures username presence' do
#     user = User.new(email: Faker::Name.email, password: 'password').save
#     expect(user).to  eq(false)
#   end
#   it 'ensures email presence' do
#     user = User.new(name: Faker::Name.name, password: 'password').save
#     expect(user).to  eq(false)
#   end
#   it 'should save successfully' do
#     user = User.new(name: Faker::Name.name, email: Faker::Name.email, password: 'password').save
#     expect(user).to  eq(true)
#   end
#
#   # it 'should only add first one' do
#   #   user1 = FactoryBot.create(:user)
#   #   expect(user1).to be_valid
#   #
#   #   user2 = FactoryBot.build(:user, name: user1.name, email: user1.email)
#   #   expect(user2).to_not be_valid
#   # end
#   describe "validations" do
#     let(:user1) { create(:user, password:  'password') }
#     it "should not allow duplicate records" do
#       # Create a user with some attributes
#
#
#       # Try to create another user with the same attributes
#       user2 = User.new(name: :user1.name, email: :user1[:email], password: 'password').save
#       expect(user2).to_not be_valid
#       expect(user2.errors[:name]).to include("has already been taken")
#       expect(user2.errors[:email]).to include("has already been taken")
#     end
#   end
#
#   #pending "add some examples to (or delete) #{__FILE__}"
# end
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
      user = create(:user, password: "password123")
      expect(user.password_digest).not_to eq("password123")
    end
  end

end