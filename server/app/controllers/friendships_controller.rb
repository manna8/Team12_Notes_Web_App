class FriendshipsController < ApplicationController
  #before_action :set_friendship, only: [ :show, :update, :destroy, :check_if_admin_or_in_relation, :check_if_admin_or_receiver ]
  before_action :authenticate_user!
  before_action :authorize_admin!, only:[:index, :show, :all_friendships_with_names]
  before_action :check_if_admin_or_in_relation, only: [:destroy]
  before_action :check_if_admin_or_receiver, only: [:update]

  # GET /friendships
  # GET /friendships.json
  def index
    @friendships = Friendship.all
    render json: @friendships
  end


  def all_friendships_with_names
    friendships = Friendship.all
    friendships_names = friendships.map{|friendship| {_id: friendship.id,
                                                      sender: friendship.sender_id,
                                                      receiver: friendship.receiver_id,
                                                      status: friendship.status} }
    friendships_names.each do |friendship|
      sender = User.find_by(id: friendship[:sender])
      receiver = User.find_by(id: friendship[:receiver])

      friendship[:sender] = sender.name
      friendship[:receiver] = receiver.name

    end
    render json: friendships_names
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
      render json: { json: @friendship.errors.full_messages }, status: :unprocessable_entity
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
      render json: {errors:@friendship.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /friendships/1
  # DELETE /friendships/1.json
  def destroy

    user = User.find_by(id: @friendship[:sender_id])
    user.pull(friend_ids: @friendship[:receiver_id])
    user.save
    user = User.find_by(id: @friendship[:receiver_id])
    user.pull(friend_ids: @friendship[:sender_id])
    user.save

    if @friendship.destroy
      render json: {message:"Friendship deleted"}, status: :ok
    else
      render json: { errors: @friendship.errors.full_messages }, status: :unprocessable_entity
    end
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

  def check_if_admin_or_in_relation
    @friendship = Friendship.find(params[:id])
    unless @friendship[:sender_id] == @current_user[:id] ||
      @friendship[:receiver_id] == @current_user[:id] ||
      @is_admin
      render json: { error: 'Not authorized' }, status: :unauthorized
    end
  end
  def check_if_admin_or_receiver
    @friendship = Friendship.find(params[:id])
    unless @friendship[:receiver_id] == @current_user[:id] || @is_admin
      render json: { error: 'Not authorized' }, status: :unauthorized
    end
  end
end
