# app/controllers/api/v1/members_controller.rb

module Api
    module V2
      class EventsController < ApplicationController
        before_action :set_service, only: [:create,:update,:update_event_score_type]
        def index
          message={}
          events=ActiveModelSerializers::SerializableResource.new(Event.all, each_serializer: EventSerializer)
          message[:events]=events
          render json: {success: true,message: message}, status: :ok
        end

        def get_event_by_id
          begin
            event=Event::FetchEvenService.new().fetch_event_by_id(params[:id])
            render json: { success: true, message:  event}, status: :ok
          rescue ActiveRecord::RecordNotFound
            render json: { success: false, message: { errors: ["Event not found"] } }, status: :not_found
          rescue => e
            Rails.logger.error("Error processing request: #{e.message}")
            render json: { success: false, message: { errors: ["An unexpected error occurred"] } }, status: :internal_server_error
          end

        end

        def get_events_by_member_id
          begin
            events = Event::FetchEvenService.new().fetch_events_by_member_id(params[:member_id])
            render json: { success: true, message: events}, status: :ok
          rescue ActiveRecord::RecordNotFound
            render json: { success: false, message: { errors: ["Member not found"] } }, status: :not_found
          rescue => e
            render json: { success: false, message: { errors: [e.message] } }, status: :internal_server_error
          end
        end

        def update
          filtered_params = event_params.except(:score_type_id)
          @event = Event.new(filtered_params)
          authorize @event
          result=@update_service.update
          message={}
          message[:event] = result[:event]
          render json: {success: true,message: message}, status: :ok
        end

        def update_status
          event=params.require(:event).permit(:status,:id)
          @update_service= Event::UpdateService.new
          result=@update_service.update_status(event)
          message={}
          message[:event] = result[:event]
          render json: {success: true,message: message}, status: :ok
        end
        def update_event_score_type
          result=@update_service.update_event_score_type(params[:event_id],params[:score_type_id])
          message={}
          message[:event]=result[:event]
          render json: {success: true,message: message}, status: :ok
        end

        def get_events_by_judge_id
          events = Event.joins(:judges).where(judges: { member_id: params[:member_id] })
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
          params.require(:event).permit(:id,:name, :desc, :active, :start_date, :end_date, :start_time, :end_time, :all_day, :location, :event_type_id,:score_type_id )
        end
        def set_service
          @service = Event::CreateService.new(event_params,current_user)
          @update_service= Event::UpdateService.new(event_params,current_user)

        end

      end
    end
  end
