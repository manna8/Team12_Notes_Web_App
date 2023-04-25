class SessionsController < ApplicationController

  include ActionController::Cookies
  before_action :authenticate_user! , only: [:show, :destroy]

  def create
    user = User.find_by(:email => params[:email])
    if user && user.authenticate(params[:password])
      jwt = encode_token({user_id: user.id})
      cookies[:jwt] = { value: jwt, httponly: true, domain: '.127.0.0.1',  expires: 1.month.from_now, same_site: :none, secure: true}
      render json: { message: 'Logged in successfully.' }, status: :ok
    else
      render json: { message: 'Invalid email or password.' }, status: :unauthorized
    end
    rescue Mongoid::Errors::DocumentNotFound
    render json: { message: 'Invalid email or password.' }, status: :unauthorized
  end

    def show
    render json: @current_user
  end


  def destroy
    if cookies.delete(:jwt, domain: '.127.0.0.1', path: "/", secure: true, httponly: true, expires: Time.at(0), same_site: :none)
      @current_user = nil
      render json: { message: 'Logged out successfully.' }, status: :ok
    else
      render json: { message: 'Unable to logout' }, status: :unprocessable_entity
    end
  end
end
