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


  def update
    if @user.update(user_params)
      render json: { message: 'Note updated successfully.'}, status: :ok
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    cookies.delete(:jwt, domain: '.127.0.0.1', path: "/", secure: true, httponly: true, expires: Time.at(0), same_site: :none)
    @current_user = nil
    # puts @current_user
    render json: { message: 'Logged out successfully.' }, status: :ok
  end

  private

  def set_note
    @user = User.find(params[:id])
  end
  def user_params
    params.permit(:name, :email, :password, :password_confirmation)
  end


end
