class ApplicationController < ActionController::API
  include ActionController::Cookies
  #before_action :authenticate_user!

  def authenticate_user!
    jwt_token = cookies[:jwt]
    if jwt_token
      begin
        decoded_token = JWT.decode(jwt_token, Rails.application.secrets.secret_key_base, true, algorithm: 'HS256')
        user_id = decoded_token.first['user_id']
        @current_user = User.find_by(id: user_id)
      rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
        @current_user = nil
      end
    end

    unless @current_user
      render json: { error: 'Not authenticated' }, status: :unauthorized
    end
  end
  include ActionController::Cookies
  def encode_token(payload)
    JWT.encode(payload, Rails.application.secret_key_base)
  end

  def decode_token(token)
    JWT.decode(token, Rails.application.secret_key_base)[0]
  end



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