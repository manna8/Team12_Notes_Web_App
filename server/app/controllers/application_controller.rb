class ApplicationController < ActionController::API
  include ActionController::Cookies
  #before_action :authenticate_user! , only: [:show]
  #before_action :authenicate_user, only: [:show]
  def authenticate_user!
    jwt_token = cookies[:jwt]
    if jwt_token
      begin
        decoded_token = decode_token(jwt_token)
        user_id = decoded_token["user_id"]["$oid"]
        @current_user = User.find_by(id: user_id)
        if @current_user[:role] == "admin"
          @is_admin = true
        else
          @is_admin = false
        end
      rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
        @current_user = nil
        @is_admin = false
        end
      end
      unless @current_user or @is_admin
        render json: { error: 'Not authenticated' }, status: :unauthorized
      end
    end

    def authorize_admin!
      unless @is_admin
        render json: { error: 'Not authorized' }, status: :forbidden
      end
    end


  def check_admin
    if @current_user[:role] != "admin"
      render json: { error: 'You are not an admin' }, status: :unauthorized
    end
  end
  def encode_token(payload)
    JWT.encode(payload, Rails.application.secret_key_base)
  end

  def decode_token(token)
    JWT.decode(token, Rails.application.secret_key_base)[0]
  end


  # def authenticate_user
  #   jwt = cookies.signed[:jwt]
  #   decode_token(jwt)
  # end
  #
  #before_action :authenticate_user!

  # def authenticate_user!
  #   jwt_token = cookies[:jwt]
  #   begin
  #     decoded_token = decode_token(jwt_token)
  #     @current_user = User.find(decoded_token['user_id'])
  #   rescue JWT::DecodeError
  #     render json: { message: 'Invalid token.' }, status: :unauthorized
  #   rescue Mongoid::Errors::DocumentNotFound
  #     render json: { message: 'User not found.' }, status: :unauthorized
  #   end
  #
  # end

  def current_user
    @current_user
  end

end
#   include ActionController::Cookies
#
#   def authenticate_user!
#     jwt_token = cookies[:jwt]
#     if jwt_token.nil?
#       render json: { message: 'You must be logged in to do that.' }, status: :unauthorized
#       return
#     end
#
#     begin
#       decoded_token = User.decode_token(jwt_token)
#       @current_user_id = decoded_token[:user_id]
#     rescue JWT::DecodeError
#       render json: { message: 'Invalid token.' }, status: :unauthorized
#     end
#
#     @current_user = User.find_by(id: @current_user_id)
#     if @current_user.nil?
#       render json: { message: 'User not found.' }, status: :unauthorized
#     end
#   end
#end