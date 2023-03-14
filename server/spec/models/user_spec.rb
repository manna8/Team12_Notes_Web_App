require 'rails_helper'

RSpec.describe User, type: :model do
  it 'ensures username presence' do
    user = FactoryBot.create(:user)
    user = User.new(email: 'email', password: 'password').save
    expect(user).to  eq(false)
  end
  it 'ensures email presence' do
    user = User.new(name: 'username', password: 'password').save
    expect(user).to  eq(false)
  end
  it 'should save successfully' do
    user = User.new(name: 'username', email: 'email', password: 'password').save
    expect(user).to  eq(true)
  end

  # it 'should only add first one' do
  #   user1 = FactoryBot.create(:user)
  #   expect(user1).to be_valid
  #
  #   user2 = FactoryBot.build(:user, name: user1.name, email: user1.email)
  #   expect(user2).to_not be_valid
  # end
  describe "validations" do
    it "should not allow duplicate records" do
      # Create a user with some attributes
      user1 = FactoryBot.build(:user, name: "J", email: "j@example.com")

      # Try to create another user with the same attributes
      user2 = FactoryBot.build(:user, name: "J", email: "j@example.com")
      expect(user2).to_not be_valid
      expect(user2.errors[:name]).to include("has already been taken")
      expect(user2.errors[:email]).to include("has already been taken")
    end
  end

  #pending "add some examples to (or delete) #{__FILE__}"
end