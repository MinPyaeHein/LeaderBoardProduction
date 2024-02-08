# app/controllers/api/v1/members_controller.rb

module Api
    module V1
      class EventsController < ApplicationController
        before_action :set_service, only: [:create]
        def index
          render json:Event.all
          
        end

       
        def create
          
          @service = Event::CreateService.new(event_params)
          result=@service.create()
          message={}
          if result[:event]
            message=true
            message = result[:event]
            render json:{message: message}, status: :created
          else
            message[:success] = false
            message[:errors] = result[:errors]
            render json: { message: message }, status: :unprocessable_entity
  
          end
        end

        private
        def event_params
          params.require(:event).permit(:name, :desc, :active, :start_date, :end_date, :start_time, :end_time, :all_day, :location, :event_type_id,:organizer_id,:score_type_id )
        end
        def set_service
          @service = ScoreType::CreateService.new(event_params)
        end

      end
    end
  end
  