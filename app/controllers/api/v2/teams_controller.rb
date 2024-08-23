# app/controllers/api/v1/members_controller.rb

module Api
    module V2
      class TeamsController < ApplicationController

        before_action :set_service, only: [:create,:create_team_with_leaders,:update, :update_status]
        def index
          message={}
          message[:teams] = ActiveModelSerializers::SerializableResource.new(Team.all, each_serializer: TeamWithVoteCountSerializer).as_json
          render json:{success: true,message: message}
        end
        def get_teams_by_event_id
          message={}
          message[:teams] = ActiveModelSerializers::SerializableResource.new(Team.where(event_id:params[:event_id]), each_serializer: TeamWithVoteCountSerializer).as_json
          render json:{success: true,message: message}
        end
        def update
          result=@update_service.update
          message={}
          if result[:team].present?
            message[:team] = result[:team]
            render json:{success: true,message: message}
         else
           message[:error] = result[:error]
           render json:{success: false,message: message}
         end
        end
        def update_status
          team_params = params.require(:team).permit(:status, :id)
          @team = Team.find_by(id: team_params[:id])

          unless @team
            return render json: { success: false, message: { errors: 'Team not found in the system' } }, status: :not_found
          end

          authorize @team

          result = Team::UpdateService.new.update_status(team_params)

          render json: {
            success: result[:team].present?,
            message: result[:team].present? ? { team: result[:team] } : { errors: result[:error] }
          }
        end

        def create
          result=@service.create()
          if result[:success]
            render json:result, status: :created
          else
            render json: result, status: :unprocessable_entity
          end
        end

        def create_team_with_leaders
          filtered_params = team_params.except(:member_ids)
          @team = Team.new(filtered_params)
          authorize @team
          message=@service.createTeamWithLeaders()

          render json: message, status: :created

        end
        def get_teams_total_amount_by_event_id
          message = {}
          teams = Team.where(event_id: params[:event_id])

          if teams.present?
            message[:teams] = ActiveModelSerializers::SerializableResource.new(teams, each_serializer: TeamWithVoteCountSerializer).as_json
            render json: { success: true, message: message }, status: :ok
          else
            message[:errors] = "No teams found for the event"
            render json: { success: false, message: message }, status: :not_found
          end
        end

        def get_teams_by_id
          team = Team.find_by(id: params[:team_id])
          message = {}
          if team.present?
            message[:team] = ActiveModelSerializers::SerializableResource.new(team, serializer: TeamWithVoteCountSerializer).as_json
            render json: { success: true, message: message }, status: :ok
          else
            message[:errors] = "No team found with the provided ID"
            render json: { success: false, message: message }, status: :not_found
          end
        end

        def get_teams_by_member_id
          message = {}
          team_members = TeamMember.includes(:team).where(member_id: params[:member_id])
          serialized_team_member = ActiveModelSerializers::SerializableResource.new(team_members,each_serializer: TeamMemberSerializer)
          if team_members.present?
            message[:team_members] = serialized_team_member
            render json: { success: true, message: message }
          else
            message[:errors] = "Team Member did not found in database"
            render json: { success: false, message: message }
          end
        end

        private
        def team_params
          params.require(:team).permit(:id,:name,:leader, :desc, :active,:website_link, :event_id, :total_score,:member_id, member_ids: [])
        end
        def set_service
          @update_service = Team::UpdateService.new(team_params)
          @service = Team::CreateService.new(team_params,@current_user)
        end

      end
    end
  end
