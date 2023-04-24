class UsersController < ApplicationController

  before_action :authenticate_user!, only: [:show, :update, :destroy, :friends]
  before_action :authorize_admin!, only:[:all_users, :show_user_with_id]
  before_action :set_user, only: %i[update destroy]


  include ActionController::Cookies
  def show
    render json: { user: @current_user }
  end

  def show_user_with_id
    user = User.find(params[:id])
    render json: user
  end

  def friends
    friends_id  = User.find_by(:id => @current_user[:id]).friend_ids

    friends =  friends_id.map{|id| {name: "", id: id } }
    friends.each do |shared|
      user = User.find_by(id: shared[:id])
      shared[:name] = user.name
    end
    render json: friends
  end

  def all_users
    @users = User.all
    render json:@users
  end
  def create
    user = User.new(user_params)
    if user.save
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

    @collections= NotesCollection.where(:user_id => @user[:id])


    if @notes.destroy && @collections.destroy && @user.destroy
      render json: { message: 'User deleted successfully.' }, status: :ok
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
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
