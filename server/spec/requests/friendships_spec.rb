require 'rails_helper'

RSpec.describe FriendshipsController, type: :controller do
  describe "POST #create" do
    let(:sender) { create(:user , password:  'password') }
    let(:receiver) { create(:user) }

    let(:friendship) {create(:friendship)}

    before do
      old_controller = @controller
      @controller = SessionsController.new
      post :create, params: { email: sender.email, password:  'password'}
      @controller = old_controller

    end
    context "with valid attributes" do
      it "creates a new friendship" do
        expect {
          post :create, params: { email: receiver.email}
        }.to change(Friendship, :count).by(1)
      end
    end

    context "with invalid attributes" do
      it "does not create a new friendship" do
        expect {
          post :create, params: { friendship: { sender_id: sender.id, receiver_id: sender.id } }
        }.to_not change(Friendship, :count)
        expect(Friendship.last.status).to eq('pending')
      end
    end
  end

  describe "POST update" do
    let(:user) { FactoryBot.create(:user) }
    let(:friend) { FactoryBot.create(:user) }
    let(:friendship) { FactoryBot.create(:friendship, sender_id: user.id, receiver_id: friend.id) }

    context "when the friendship is successfully updated" do
      before { post :update, params: { id: friendship.id, status: 'accepted' } }

      it "updates the status of the friendship" do
        expect(friendship.reload.status).to eq('accepted')
      end

    end

    context "when the friendship cannot be updated" do
      before { put :update, params: { id: friendship.id, status: nil } }

      it "does not update the status of the friendship" do
        expect(friendship.reload.status).to eq('pending')
      end


    end
  end

  describe "DELETE destroy" do
    let(:user) { FactoryBot.create(:user) }
    let(:friend) { FactoryBot.create(:user) }
    let!(:friendship) { FactoryBot.create(:friendship, sender_id: user.id, receiver_id: friend.id) }

    context "when the friendship is successfully destroyed" do
      before { delete :destroy, params: { id: friendship.id } }

    end

    context "when the friendship cannot be destroyed" do
      before do
        allow_any_instance_of(Friendship).to receive(:destroy).and_return(false)
        delete :destroy, params: { id: friendship.id }
      end


    end
  end
end
