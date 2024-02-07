# app/controllers/authentication_controller.rb

class AuthenticationController < ApplicationController
  def authenticate
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      token = user.generate_jwt
      render json: { token: token }
    else
      render json: { error: 'Invalid credentials' }, status: :unauthorized
    end
  end
end
