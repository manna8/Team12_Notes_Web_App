class UsersController < ApplicationController

  before_action :authenticate_user!, only: [:show]
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
