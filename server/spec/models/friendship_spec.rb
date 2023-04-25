require 'rails_helper'

RSpec.describe Friendship, type: :model do
  let(:user1) { FactoryBot.create(:user) }
  let(:user2) { FactoryBot.create(:user) }

  it "is valid with valid attributes" do
    friendship = Friendship.new(sender_id: user1.id, receiver_id: user2.id, status: "pending")
    expect(friendship).to be_valid
  end

  it "is not valid without a status" do
    friendship = Friendship.new(sender_id: user1.id, receiver_id: user2.id)
    expect(friendship).to_not be_valid
  end

  it "is not valid without a sender_id" do
    friendship = Friendship.new(receiver_id: user2.id, status: "pending")
    expect(friendship).to_not be_valid
  end

  it "is not valid without a receiver_id" do
    friendship = Friendship.new(sender_id: user1.id, status: "pending")
    expect(friendship).to_not be_valid
  end

end
