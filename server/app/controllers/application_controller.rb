class ApplicationController < ActionController::API
  include ActionController::Cookies

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



  def encode_token(payload)
    JWT.encode(payload, Rails.application.secret_key_base)
  end

  def decode_token(token)
    JWT.decode(token, Rails.application.secret_key_base)[0]
  end

  def current_user
    @current_user
  end

end
