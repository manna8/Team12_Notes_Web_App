class UsersController < ApplicationController

  before_action :authenticate_user!, only: [:show, :update, :destroy]
  before_action :authorize_admin!, only:[:all_users]
  before_action :set_user, only: %i[update destroy]


  include ActionController::Cookies
  def show
    render json: { user: current_user }
  end

  def all_users
    @users = User.all
    render json:@users
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
      render json: { message: 'User updated successfully.'}, status: :ok
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @notes = Note.where(:user_id => @user[:id])
    @notes.destroy
    @collections= NotesCollection.where(:user_id => @user[:id])
    @collections.destroy
    @user.destroy
    render json: { message: 'User deleted successfully.' }, status: :ok
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
  def user_params
    if params[:password].present? && params[:password_confirmation].present?
      params.permit(:name, :email, :password, :password_confirmation)
    else
      params.permit(:name, :email)
    end
  end


end
