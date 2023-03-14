class UsersController < ApplicationController
  # before_action :getUser
  # def index
  #   if @current_user.admin?
  #     @users = User.all
  #     render json: @users
  #   else
  #     render json: { error: 'Not authorized' }, status: :forbidden
  #   end
  # end
  #
  # def self.authenticate(email, password)
  #   user = find_by(email: email)
  #   if user && user.authenticate(password)
  #     user
  #   end
  # end
  #
  #
  # def get
  #   user = User.all
  #   if user
  #     render json: user, status: :ok
  #   else
  #     render json: { message: "No user" }, status: :unprocessable_entity
  #   end
  # end
  # # def create
  # #   user = User.new(user_params)
  # #   if user.save
  # #     render json: user, status: :ok
  # #   else
  # #     render json: { message: "User not added" }, status: :unprocessable_entity
  # #
  # #   end
  # # end
  #
  #
  # def new
  #   @user = User.new
  # end
  #
  # def create
  #   @user = User.new(user_params)
  #
  #   if @user.save
  #     jwt_token = JWT.encode({ user_id: @user.id }, Rails.application.secret_key_base)
  #     cookies[:jwt] = { value: jwt_token, httponly: true, expires: 1.week.from_now }
  #     render json: { status: 'success', user: @user }
  #   else
  #     render json: { status: 'error', errors: @user.errors.full_messages }
  #   end
  # end
  #
  #
  # private
  # def user_params
  #   params.permit(:name,:email,:password, :'user')
  # end
  # def getUser
  #   @user = User.find(params[:id])
  # end
  #before_action :authenticate_user!, only: [:show]
  include ActionController::Cookies
  def show
    render json: { user: current_user }
  end

  def create
    user = User.new(user_params)
    if user.save
      jwt = encode_token(user_id: user.id)
      cookies[:jwt] = { value: jwt, httponly: true }
      render json: { message: 'User created successfully.' }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:name, :email, :password, :password_confirmation)
  end


end
