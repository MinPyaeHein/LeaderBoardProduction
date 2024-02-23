class ApplicationController < ActionController::API
    before_action :authenticate_request

    private
  
    def authenticate_request
      # Your authentication logic here, for example:
      unless current_user
        render json: { error: 'Unauthorized' }, status: :unauthorized
      end
    end
  
    def current_user
    
      @current_user ||= User.decode_jwt(request.headers['Authorization'])
    end
    def nothing
      head :not_found
    end
end
