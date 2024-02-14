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
      message={}
      message[:judge]=judge
      message[:member]=judge.member
      message[:ongoing_events]=ongoing_events
      message[:past_events]=past_events
      message[:future_events]=future_events
      render json: {message: message, success: true}, status: :ok
    else
      render json: { error: 'Judge not found for the provided member_id' }, status: :not_found
    end
  end
        def create 
          result=@service.create()
          message={}
          if result.present?
            message[:judges] = result[:judges]
            message[:errors] = result[:errors]
            render json:{success: true,message: message}, status: :created
          end
        end

        def get_judges_by_event_id
          event_id = params[:event_id] # Assuming you're passing event_id as a parameter         
          # Fetching judges associated with the given event for the specified team
          members = Member.joins(:judges)
                         .where('judges.event_id = ?', event_id)
                         .select('judges.*') # Selecting only judge attributes
          puts "members #{members}"
          # members = judges.map(&:member)
          message={}   
          message[:members]=members
          render json: {success: true,message: message}
        end
        private
        def judge_params
          params.require(:judge).permit(:event_id ,:active, :current_amount, member_ids: [])
        end
        def set_service
          @service = Judge::CreateService.new(judge_params)
        end

      end
    end
  end
  