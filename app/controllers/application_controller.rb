class ApplicationController < ActionController::API
    include Pundit
    before_action :authenticate_request
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
    private

    def authenticate_request

      unless current_user
        render json: { error: 'Unauthorized' }, status: :unauthorized
      end
    end
    def user_not_authorized
      render json: { error: "You are not authorized to perform this action." }, status: :forbidden
    end

    def current_user
      puts("token==",request.headers['Authorization']&.split(' ')&.last)
      @current_user ||= User.decode_jwt(request.headers['Authorization']&.split(' ')&.last)
    end
    
    def nothing
      head :not_found
    end
end
