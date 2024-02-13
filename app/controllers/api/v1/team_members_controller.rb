# app/controllers/api/v1/members_controller.rb

module Api
    module V1
      class TeamMembersController < ApplicationController
        before_action :set_service, only: [:create]
       
        def index
          teamMembers = TeamMember.all
          message={}
          message[:teamMembers]=teamMembers
          render json: {success: true,message: message}
        end

        def get_members_by_team_id
          team_id = params[:team_id] # assuming you're passing team_id as a parameter
          members = Member.joins(:teams).where(teams: { id: team_id }).distinct
          message={}
          message[:members]=members
          render json: {success: true,message: message}
        end
       
        def create 
          result=@service.create()
          message={}
          if result[:teamMember].present?
            message[:teamMember] = result[:teamMember]
            render json:{success: true,message: message}, status: :created
          else
            message[:errors] = result[:errors]
            render json: {success: false ,message: message }, status: :unprocessable_entity
  
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
  