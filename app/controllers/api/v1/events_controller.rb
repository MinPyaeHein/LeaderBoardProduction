# app/controllers/api/v1/members_controller.rb

module Api
    module V1
      class EventsController < ApplicationController
        before_action :set_service, only: [:create]
        def index
          render json:Event.all
          
        end

       
        def create
          
          @service = Event::CreateService.new(event_type_params)
          event_type=@service.create()
          if @service
            render json: event_type, status: :created
          else
            render json: { errors: event_type.create_event_type.errors.full_messages }, status: :unprocessable_entity
          end
        end

        private
        def event_type_params
          params.require(:event).permit(:name, :desc, :active, :event_type_id)
        end
        def set_service
          @service = ScoreType::CreateService.new(event_type_params)
        end

      end
    end
  end
  