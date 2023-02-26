class UsersController < ApplicationController
  # before_action :getUser
  def index
  end
  def get
    user = User.all
    if user
      render json: user, status: :ok
    else
      render json: { message: "No user" }, status: :not_ok
    end
  end
  def create
    user = User.new(user_params)
    if user.save
      render json: user, status: :ok
    else
      render json: { message: "User not added" }, status: :error


    end
  end

  private
  def user_params
    params.permit(:name,:email,:password, :'user')
  end
  def getUser
    @user = User.find(params[:id])
  end
end
