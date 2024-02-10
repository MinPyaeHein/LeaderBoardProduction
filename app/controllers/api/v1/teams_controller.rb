# app/controllers/api/v1/members_controller.rb

module Api
    module V1
      class TeamsController < ApplicationController
        before_action :set_service, only: [:create]
        def index
          message={}
          message[:teams]=Team.all
          render json:{message: message}
        end

       
        def create
          
          
          result=@service.create()
          message={}
          if result[:team].present?
            message[:success] = true
            message = result[:team]
            render json:{message: message}, status: :created
          else
            message[:success] = false
            message[:errors] = result[:errors]
            render json: { message: message }, status: :unprocessable_entity
  
          end
        end

        private
        def team_params
          params.require(:team).permit(:name, :desc, :active,:website_link , :leader_id, :event_id, :total_score)
        end
        def set_service
          @service = Team::CreateService.new(team_params,current_user)
        end

      end
    end
  end
  