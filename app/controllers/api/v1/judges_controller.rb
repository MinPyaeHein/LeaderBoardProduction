# app/controllers/api/v1/members_controller.rb

module Api
    module V1
      class JudgesController < ApplicationController
        before_action :set_service, only: [:create]
       
        def index
          @judges = Judge.where(active: true)
          message={}
          message[:success]=true
          message[:judges]=@judges
          render json: {message: message}
        end

        def events_by_member_id
    # Find the judge and associated member by member_id
    judge = Judge.includes(:member).find_by(member_id: params[:member_id])

    if judge
      # Get ongoing, past, and future events
      ongoing_events = Event.where(status: :ongoing)
      past_events = Event.where(status: :past)
      future_events = Event.where(status: :future)

      # Filter events with active=true
      ongoing_events = ongoing_events.where(active: true)
      past_events = past_events.where(active: true)
      future_events = future_events.where(active: true)

      render json: {
        judge: judge,
        member: judge.member,
        ongoing_events: ongoing_events,
        past_events: past_events,
        future_events: future_events
      }
    else
      render json: { error: 'Judge not found for the provided member_id' }, status: :not_found
    end
  end

       
       
        def create 
          result=@service.create()
          message={}
          if result[:judge].present?
            message[:success] = true
            message[:judge] = result[:judge]
            render json:{message: message}, status: :created
          else
            message[:success] = false
            message[:errors] = result[:errors]
            render json: { message: message }, status: :unprocessable_entity
  
          end
        end

        private
        def judge_params
          params.require(:judge).permit(:member_id,:event_id ,:active, :current_amount)
        end
        def set_service
          @service = Judge::CreateService.new(judge_params)
        end

      end
    end
  end
  