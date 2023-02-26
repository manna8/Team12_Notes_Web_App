class LoginController < ApplicationController
  def login
    user = User.find_by(:name => params[:name])
    if user
      if user.authenticate(params[:password])
        render json:{message: "You are logged in "}, status: :ok
      else
        render json:{message: "Wrong password"}, status: :bad
      end
    else
      render json:{message: "User doesn't exist"}, status: :bad
    end
  end
end
