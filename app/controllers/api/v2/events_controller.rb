# app/controllers/api/v1/members_controller.rb

module Api
    module V2
      class EventsController < ApplicationController
        before_action :set_service, only: [:create,:update,:update_event_score_type]
        def index
          message={}
          message[:events]=Event.all
          render json: {success: true,message: message}, status: :ok
        end

        def get_events_by_id
          begin
            @event = Event.includes(:teams, :organizer, :judges, :editors, :event_type, :score_type).find(params[:id])
            message = {
              event: @event,
              organizer: @event.organizer,
              judges: @event.judges,
              teams: @event.teams,
              editors: @event.editors,
              event_type: @event.event_type,
              score_type: @event.score_type
            }
            render json: { success: true, message: message }, status: :ok
          rescue ActiveRecord::RecordNotFound
            render json: { success: false, message: { errors: ["Event not found"] } }, status: :not_found
          rescue => e
            Rails.logger.error("Error processing request: #{e.message}")
            render json: { success: false, message: { errors: ["An unexpected error occurred"] } }, status: :internal_server_error
          end
        end

        def get_event_by_member_id
          begin
            member = Member.find(params[:member_id])

            organized_events = ActiveModelSerializers::SerializableResource.new(member.events, each_serializer: EventSerializer)
            judged_events = ActiveModelSerializers::SerializableResource.new(Event.joins(:judges).where(judges: { member_id: member.id }), each_serializer: EventSerializer)
            team_member_events = ActiveModelSerializers::SerializableResource.new(Event.joins(teams: :team_members).where(team_members: { member_id: member.id }), each_serializer: EventSerializer)
            edited_events = ActiveModelSerializers::SerializableResource.new(Event.joins(:editors).where(editors: { member_id: member.id }), each_serializer: EventSerializer)

            message = {
              organized_events: organized_events,
              judged_events: judged_events,
              team_member_events: team_member_events,
              edited_events: edited_events
            }

            render json: { success: true, message: message }, status: :ok
          rescue ActiveRecord::RecordNotFound
            render json: { success: false, message: { errors: ["Member not found"] } }, status: :not_found
          rescue => e
            Rails.logger.error("Error processing request: #{e.message}")
            render json: { success: false, message: { errors: ["An unexpected error occurred"] } }, status: :internal_server_error
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
          params.require(:event).permit(:id,:name, :desc, :active, :start_date, :end_date, :start_time, :end_time, :all_day, :location, :event_type_id,:score_type_id )
        end
        def set_service
          @service = Event::CreateService.new(event_params,current_user)
          @update_service= Event::UpdateService.new(event_params,current_user)

        end

      end
    end
  end
