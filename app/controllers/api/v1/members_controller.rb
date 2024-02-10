# app/controllers/api/v1/members_controller.rb

module Api
    module V1
      class MembersController < ApplicationController
       
        skip_before_action :authenticate_request, only: [:create, :login]
        before_action :set_service, only: [:create, :destroy, :login]

        def login
          result=@loginLogout_service.login
          if result[:token].present?
            render json: {success: true,user: result[:user], member: result[:member],token: result[:token] }, status: :created
          elsif result[:error].present?
            render json: {success: false, error: result[:error] }, status: :unprocessable_entity
          end
        end
        def logout
          render json: { message: 'Logged out successfully' }
        end
        def index
        
          active_members = Member.includes(:users).where(active: true)
          message ={members: active_members, include: :users}
          render json: message
        end

        def destroy   
          result = @destroy_service.destroy_member(params[:id])
          render json: result
        end
        def create
          result=@create_service.create_member
          message={}
          if result[:token]
            message[:token]=result[:token]
            message[:password]=result[:password]
            message[:user]=result[:user]
            message[:member]=result[:member]
            message[:success]=true
            render json: message, status: :created
          elsif result[:errors]
            message[:success]=false
            message[:errors]=result[:errors]
            render json: message, status: :unprocessable_entity
          else
            message[:errors]=result[:errors]
            render json: result[:errors], status: :unprocessable_entity
          end
        end
        def events_by_member_id
          # Find the judge and associated member by member_id
          judge = Judge.includes(:member).find_by(member_id: params[:member_id])
      
          if judge
            # Get ongoing, past, and future events
            ongoing_events = Event.where(status: :ongoing, active: true, judge_id: judge.id)
            past_events = Event.where(status: :past,active: true, judge_id: judge.id)
            future_events = Event.where(status: :future,active: true, judge_id: judge.id)
            message={}
            message[:member]=judge.member
            message[:ongoing_event]=ongoing_events
            message[:past_event]=past_events
            message[:future_event]=future_events
            render json: message
          else
            render json: { error: 'Judge not found for the provided member_id' }, status: :not_found
          end
        end

        private
        def member_params
          params.require(:member).permit(:name,:email,:password,:phone,:password,:active,:profile_url,:address,:role,:faculty_id,:org_name)
        end
        
        def set_service
          @create_service = Member::CreateService.new(member_params)
          @destroy_service = Member::DestroyService.new(member_params)
          @loginLogout_service = Member::LoginLogoutService.new(member_params)
        end 


      end
    end
  end
  