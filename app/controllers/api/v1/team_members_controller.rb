# app/controllers/api/v1/members_controller.rb

module Api
    module V1
      class TeamMembersController < ApplicationController
        before_action :set_service, only: [:create]
       
        def index
          @teamMembers = TeamMember.all
          message={}
          message[:success]=true
          message[:teamMember]=@teamMembers
          render json: {message: message}
        end

        def get_team_members_by_team
          @teamMembers = TeamMember.where(team_id: params[:team_id], active: true)
          message={}
          message[:success]=true
          message[:teamMembers]=@teamMembers
          render json: {message: message}
        end
       
        def create 
          result=@service.create()
          message={}
          if result[:teamMember].present?
            message[:success] = true
            message[:teamMember] = result[:teamMember]
            render json:{message: message}, status: :created
          else
            message[:success] = false
            message[:errors] = result[:errors]
            render json: { message: message }, status: :unprocessable_entity
  
          end
        end

        private
        def team_params
          params.require(:team_member).permit(:team_id, :member_id,:event_id ,:active, :leader)
        end
        def set_service
          @service = TeamMember::CreateService.new(team_params)
        end

      end
    end
  end
  