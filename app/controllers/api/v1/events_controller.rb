# app/controllers/api/v1/members_controller.rb

module Api
    module V1
      class EventsController < ApplicationController
        before_action :set_service, only: [:create]
        def index
          message={}
          message[:events]=Event.where(active: true)
          render json: {success: true,message: message}, status: :ok
          
        end

        def get_events_by_id
          begin
            @event = Event.includes(:teams, :organizer, :judges, :editors).find(params[:id])
            message = {
              event: @event,
              organizer: @event.organizer,
              judges: @event.judges,
              teams: @event.teams,
              editors: @event.editors
            }
            render json: { success: true, message: message }, status: :ok
          rescue ActiveRecord::RecordNotFound
            message={errors: ["Event not found"]}
            render json: { success: false, message: message }, status: :not_found
          end
        end

        def get_events_by_judge_id
          events = Event.joins(:judges).where(judges: { member_id: params[:judge_id] })
          message={}   
          message[:events]=events
          render json: {success: true,message: message}
        end      
        def create     
          result=@service.create()
          message={}
          if result[:event]       
            message[:event] = result[:event]
            render json: {success: true ,message: message}, status: :created
          else
            message[:errors] = result[:errors]
            render json: {success: false, message: message }, status: :unprocessable_entity
          end
        end

        private
        def event_params
          params.require(:event).permit(:name, :desc, :active, :start_date, :end_date, :start_time, :end_time, :all_day, :location, :event_type_id,:score_type_id,:status )
        end
        def set_service
          @service = Event::CreateService.new(event_params,current_user)
        end

      end
    end
  end
  