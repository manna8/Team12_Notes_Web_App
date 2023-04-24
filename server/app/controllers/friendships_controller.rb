class FriendshipsController < ApplicationController
  before_action :set_friendship, only: %i[ show update destroy ]
  before_action :authenticate_user!
  before_action :authorize_admin!, only:[:index, :show]
  # GET /friendships
  # GET /friendships.json
  def index
    @friendships = Friendship.all
  end

  # GET /friendships/1
  # GET /friendships/1.json
  def show
    render json:@friendship
  end

  def friends
    friends_id  = Friendship.where(status: "accepted", sender_id: @current_user.id).pluck(:id, :receiver_id) +
                  Friendship.where(status: "accepted", receiver_id: @current_user.id).pluck(:id, :sender_id)

    friends = friends_id.map{|id, name| {name: name, friendship_id: id } }
    friends.each do |friend|
      user = User.find_by(id: friend[:name])
      friend[:name] = user.name
    end

    render json: friends
  end
  def sent_friend_requests

    sent_friendships = Friendship.where(sender_id: @current_user.id, status: "pending")
    sent_users = User.in(id: sent_friendships.pluck(:receiver_id)).pluck(:name)
    friendship_ids = sent_friendships.pluck(:id)
    sent_data = sent_users.zip(friendship_ids).map { |name, id| { name: name, friendship_id: id } }
    render json: sent_data

  end

  def received_friend_requests

    received_friendships = Friendship.where(receiver_id: @current_user.id, status: "pending")
    received_users = User.in(id: received_friendships.pluck(:sender_id)).pluck(:name)
    friendship_ids = received_friendships.pluck(:id)
    sent_data = received_users.zip(friendship_ids).map { |name, id| { name: name, friendship_id: id } }
    render json: sent_data
  end
  # POST /friendships
  # POST /friendships.json
  def create
    if params[:email] == @current_user.email
      render json: {message:"You can't send request to yourself"}, status: :unprocessable_entity
      return
    end


    @receiver = User.where(:email => params[:email]).first

    if @receiver.nil?
      render json: {message:"User does not exist"}, status: :unprocessable_entity
      return
    end
    if Friendship.where(sender_id: @current_user.id, receiver_id: @receiver.id).exists? ||
      Friendship.where(sender_id:@receiver.id , receiver_id: @current_user.id).exists?
      render json: {message:"There is already a friendship request"}, status: :unprocessable_entity
      return
    end

    @friendship = Friendship.new(:sender_id => @current_user.id,
                                 :receiver_id =>@receiver.id,
                                 :status => "pending")

    if @friendship.save
      render  json: {message:"Friendship request created"},status: :created
    else
      render json: @friendship.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /friendships/1
  # PATCH/PUT /friendships/1.json
  def update
    if status_update_params[:status] == "accepted"
      user = User.find_by(id: @friendship[:sender_id])
      user.friend_ids.push(@friendship[:receiver_id])
      user.save
      user = User.find_by(id: @friendship[:receiver_id])
      user.friend_ids.push(@friendship[:sender_id])
      user.save
      end


    if @friendship.update(status_update_params)
      render json: {message:"Friendship request status updated"}, status: :ok
    else
      render json: @friendship.errors, status: :unprocessable_entity
    end
  end

  # DELETE /friendships/1
  # DELETE /friendships/1.json
  def destroy
    @friendship.destroy

    user = User.find_by(id: @friendship[:sender_id])
    user.pull(friend_ids: @friendship[:receiver_id])
    user.save
    user = User.find_by(id: @friendship[:receiver_id])
    user.pull(friend_ids: @friendship[:sender_id])
    user.save
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_friendship
      @friendship = Friendship.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def friendship_params
      params.permit(:email)
    end
  def status_update_params
    params.permit(:status)
  end
end
