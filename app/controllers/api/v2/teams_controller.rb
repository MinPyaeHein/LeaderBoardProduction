# app/controllers/api/v1/members_controller.rb

module Api
    module V2
      class TeamsController < ApplicationController

        before_action :set_service, only: [:create,:create_team_with_leaders,:update]
        def index
          message={}
          message[:teams]=Team.all
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

        def create
          @team = Team.new(team_params)
          authorize @team
          result=@service.create()
          message={}
          if !result[:errors].present?
            message[:team] = result[:team]
            message[:teamLeader]= result[:teamLeader]
            message[:teamEvent]= result[:teamEvent]
            message[:tranInvestor]= result[:tranInvestor]
            render json:{success: true,message: message}, status: :created
          else
            message[:errors] = result[:errors]
            render json: {success: false ,message: message }, status: :unprocessable_entity
          end
        end
        def create_team_with_leaders
          filtered_params = team_params.except(:member_ids)
          @team = Team.new(filtered_params)
          authorize @team
          result=@service.createTeamWithLeaders()
          message={}
          message[:teams] = result[:teams]
          message[:teamLeaders]= result[:teamLeaders]
          message[:teamEvents]= result[:teamEvents]
          message[:errors]=result[:errors]
          render json:{success: true,message: message}, status: :created

        end
        def get_teams_by_event_id
          message = {}
          teams = Team.where(event_id: params[:event_id])
          if teams.present?
            message[:teams] = teams
            render json: { success: true, message: message }
          else
            message[:errors] = "No teams found for the event"
            render json: { success: false, message: message }
          end
        end

        private
        def team_params
          params.require(:team).permit(:team_id,:name,:leader, :desc, :active,:website_link, :event_id, :total_score, member_ids: [])
        end
        def set_service
          @update_service = Team::UpdateService.new(team_params)
          @service = Team::CreateService.new(team_params,current_user)
        end

      end
    end
  end
