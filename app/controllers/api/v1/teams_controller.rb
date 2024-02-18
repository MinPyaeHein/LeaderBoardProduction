# app/controllers/api/v1/members_controller.rb

module Api
    module V1
      class TeamsController < ApplicationController
        before_action :set_service, only: [:create]
        def index
          message={}
          message[:teams]=Team.all
          render json:{success: true,message: message}
        end

       
        def create
          
          
          result=@service.create()
          message={}
          if result[:team].present?
            message = result[:team]
            render json:{success: true,message: message}, status: :created
          else
            message[:errors] = result[:errors]
            render json: {success: false ,message: message }, status: :unprocessable_entity
          end
        end

        private
        def team_params

          params.require(:team).permit(:name, :desc, :active,:website_link, :event_id, :total_score, member_ids: [])
        end
        def set_service
          puts "team_params::::::: #{team_params}"
          @service = Team::CreateService.new(team_params,current_user)
        end

      end
    end
  end
  