class SessionsController < ApplicationController

  include ActionController::Cookies
  before_action :authenticate_user! , only: [:show, :destroy]
  # def create
  #   user = User.authenticate(params[:email], params[:password])
  #   if user
  #     jwt_token = JWT.encode({ user_id: user.id }, Rails.application.secrets.secret_key_base)
  #     cookies[:jwt] = { value: jwt_token, httponly: true }
  #     render json: { success: true }
  #   else
  #     render json: { success: false }
  #   end
  # end


  def create
    user = User.find_by(:email => params[:email])
    if user && user.authenticate(params[:password])
      jwt = encode_token({user_id: user.id})
      cookies[:jwt] = { value: jwt, httponly: true, domain: '.127.0.0.1',  expires: 1.month.from_now, same_site: :none, secure: true}
      render json: { message: 'Logged in successfully.' }, status: :ok
    else
      render json: { message: 'Invalid email or password.' }, status: :unauthorized
    end
  end



    def show
    render json: @current_user
  end


  def destroy
    cookies.delete(:jwt)
    render json: { message: 'Logged out successfully.' }, status: :ok
  end
end
