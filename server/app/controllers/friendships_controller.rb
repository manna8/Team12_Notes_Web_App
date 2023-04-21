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
    @friends = Friendship.where("(sender_id = ? OR receiver_id = ?) AND status = ?", params[:id], params[:id], "accepted")
    render json: @friends
  end
  def sent_friend_requests
    sent = Friendship.where(sender_id: params[:id], :status => "pending")
    sent_users = User.where(:id => sent[:receiver_id])
    render json: sent_users[:name]
  end

  def received_friend_requests
    sent = Friendship.where(:receiver_id => params[:id], :status => "pending")
    received_users = User.where(:id => sent[:sender_id])
    render json: received_users[:name]
  end
  # POST /friendships
  # POST /friendships.json
  def create
    receiver = User.where(:email => friendship_params[:email])

    @friendship = Friendship.new(:sender_id => @current_user[:id],
                                 :receiver_id =>receiver[:id],
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
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_friendship
      @friendship = Friendship.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def friendship_params
      params.require(:friendship).permit(:email)
    end
  def status_update_params
    params.require(:status)
  end
end
