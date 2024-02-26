# app/controllers/api/v1/members_controller.rb

module Api
    module V1
      class MembersController < ApplicationController
       
        skip_before_action :authenticate_request, only: [:create, :login]
        before_action :set_service, only: [:create, :login, :update]
        def score_boards
          render 'score_cards/home'
        end
        def login
          @recomedorService.fetching_data()
          result=@loginLogout_service.login
          message={}
          if result[:user].present?
            message[:user]=result[:user]
            message[:token]=result[:token]
            message[:member]=result[:member]
            render json: {success: true,message:message}, status: :ok
          else
            message[:success]=false
            message[:errors]=result[:errors]
            render json: message, status: :unprocessable_entity
          end
         
        end
        def logout
          render json: { message: 'Logged out successfully' }
        end
        def index
        
          active_members = Member.includes(:users).where(active: true)
          message ={members: active_members}
          render json: {success: true,message: message}, status: :ok
        end
       def reset_all
       
        if Member.destroy_all
          render json: {success: true,message: "All members successfully deleted."}, status: :ok
        else
          render json: {success: false,message: "Failed to delete all members."}, status: :unprocessable_entity
        end
      end
      def get_member_by_id
        puts "get_member_by_id----member_id ==#{params[:member_id]}"
        @member = Member.find(params[:member_id])

        message={}
        message[:member] = @member
        render json: { success: true,message: message }
      end
      def update
        result=@update_service.update
        message={}
        message[:member] = result[:member]
        render json: {success: true,message: message}, status: :ok 
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
         
          @member= Member.includes(:teams,:judges,:users,:editors).find(params[:id])
         
          if  @member
            # Filter events based on status
            ongoing_judge_events = @member.judges.joins(:event).where(events: { status: :ongoing }).select('events.*')
            past_judge_events = @member.judges.joins(:event).where(events: { status: :past }).select('events.*')
            future_judge_events = @member.judges.joins(:event).where(events: { status: :future }).select('events.*')
            
            ongoing_editor_events = @member.editors.joins(:event).where(events: { status: :ongoing }).select('events.*')
            past_editor_events = @member.editors.joins(:event).where(events: { status: :past }).select('events.*')
            future_editor_events = @member.editors.joins(:event).where(events: { status: :future }).select('events.*')
            

            message={}
            message[:users]=@users
            message[:member]=@member
            message[:teams]=@member.teams

            message[:ongoing_editor_events]=ongoing_editor_events
            message[:past_editor_events]=past_editor_events
            message[:future_editor_events]=future_editor_events

            message[:ongoing_judge_events]=ongoing_judge_events
            message[:past_judge_events]=past_judge_events
            message[:future_judge_events]=future_judge_events

            render json: message
          else
            render json: { error: 'Member not found for the provided member_id' }, status: :not_found
          end
        end

        private
        def member_params
          params.require(:member).permit(:member_id,:name,:email,:password,:phone,:password,:active,:profile_url,:address,:role,:faculty_id,:org_name, :desc)
        end
        
        def set_service
          @update_service = Member::UpdateService.new(member_params)
          @create_service = Member::CreateService.new(member_params)
          @loginLogout_service = Member::LoginLogoutService.new(member_params)
        
        end 


      end
    end
  end
  