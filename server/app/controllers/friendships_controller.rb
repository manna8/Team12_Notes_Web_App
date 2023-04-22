class FriendshipsController < ApplicationController
  before_action :set_friendship, only: %i[ show update destroy ]
  before_action :authenticate_user!
  before_action :authorize_admin!, only:[:index]
  # GET /friendships
  # GET /friendships.json
  def index
    @friendships = Friendship.all
  end

  # GET /friendships/1
  # GET /friendships/1.json
  def show
  end

  def friends
    # @friends = Friendship.where("(sender_id = ? OR receiver_id = ?) AND status = ?", @current_user.id, @current_user.id, "accepted")
    # render json: @friends[:name]

    #friends = Friendship.where("(sender_id = ? OR receiver_id = ?) AND status = ?", @current_user.id, @current_user.id, "accepted")
    #friends = Friendship.where("(sender_id = :user_id OR receiver_id = :user_id) AND status = :status", { user_id: @current_user.id, status: "accepted"})
    #friends = Friendship.where(status: "accepted").or({sender_id: @current_user.id}, {receiver_id: @current_user.id})
    #friends = Friendship.where(status: "accepted").where("sender_id = :user_id OR receiver_id = :user_id", user_id: @current_user.id)
    # friends =Friendship.where(status: "accepted", :$or => [{sender_id: @current_user.id}, {receiver_id: @current_user.id}])
    # puts friends.pluck(:receiver_id)
    # friend_users = User.in(id: friends.pluck(:receiver_id)).pluck(:name)
    # friendship_ids = friends.pluck(:id)
    # sent_data = friend_users.zip(friendship_ids).map { |name, id| { name: name, friendship_id: id } }
    # render json: sent_data
    accepted_friendships =Friendship.where(status: "accepted", :$or => [{sender_id: @current_user.id}, {receiver_id: @current_user.id}])
    user = User.find_by(id: @current_user.id)
    friends_ids = user.friend_ids
    friendship_ids = accepted_friendships.pluck(:id)
    friends = User.in(id: friends_ids).pluck(:name)
    sent_data = friends.zip(friendship_ids).map { |name, id| { name: name, friendship_id: id } }
    render json: sent_data
  end
  def sent_friend_requests
    # sent = Friendship.where(sender_id: @current_user.id, :status => "pending").first
    # sent_users = User.where(:id => sent.receiver_id).first
    # render json: sent_users.name

    # sent_friendships = Friendship.where(sender_id: @current_user.id, status: "pending")
    # sent_users = User.in(id: sent_friendships.pluck(:receiver_id)).pluck(:name)
    # render json: sent_users

    sent_friendships = Friendship.where(sender_id: @current_user.id, status: "pending")
    sent_users = User.in(id: sent_friendships.pluck(:receiver_id)).pluck(:name)
    friendship_ids = sent_friendships.pluck(:id)
    sent_data = sent_users.zip(friendship_ids).map { |name, id| { name: name, friendship_id: id } }
    render json: sent_data




  end

  def received_friend_requests
    # sent = Friendship.where(:receiver_id => @current_user[:id], :status => "pending")
    # received_users = User.where(:id => sent[:sender_id])
    # render json: received_users[:name]

    received_friendships = Friendship.where(receiver_id: @current_user.id, status: "pending")
    received_users = User.in(id: received_friendships.pluck(:sender_id)).pluck(:name)
    friendship_ids = received_friendships.pluck(:id)
    sent_data = received_users.zip(friendship_ids).map { |name, id| { name: name, friendship_id: id } }
    render json: sent_data
  end
  # POST /friendships
  # POST /friendships.json
  def create

    @receiver = User.where(:email => params[:email]).first
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
    # if status_update_params[:status] == "revoked"
    #
    # end


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
