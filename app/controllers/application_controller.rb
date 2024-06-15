class ApplicationController < ActionController::API
    before_action :authenticate_request

    private

    def authenticate_request

      unless current_user
        render json: { error: 'Unauthorized' }, status: :unauthorized
      end
    end


    def current_user
      puts("token==",request.headers['Authorization']&.split(' ')&.last)
      @current_user ||= User.decode_jwt(request.headers['Authorization']&.split(' ')&.last)

    end
    def nothing
      head :not_found
    end
end
