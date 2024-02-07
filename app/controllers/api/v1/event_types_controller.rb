# app/controllers/api/v1/members_controller.rb

module Api
    module V1
      class EventTypesController < ApplicationController
       
        before_action :set_service, only: [:create]
        def index
          render json:EventType.all
          
        end       
        def create
          eventType=@service.create()
          if @service
            render json: eventType, status: :created
          else
            render json: { errors: @service.create_event_type.errors.full_messages }, status: :unprocessable_entity
          end
        end

        private
        def member_params
          params.require(:event_type).permit(:name, :desc, :event_type_id)
        end
        def set_service
          @service = EventType::CreateService.new(member_params)
        end
        def authenticate_user
          token = request.headers['Authorization'].to_s.split(' ').last
          user = User.decode_jwt(token)
      
          render json: { error: 'Unauthorized' }, status: :unauthorized unless user
        end

      end

    end
  end
  