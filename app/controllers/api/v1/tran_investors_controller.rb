# app/controllers/api/v1/members_controller.rb

module Api
    module V1
      class TranInvestorsController < ApplicationController
        before_action :set_service, only: [:create]
        def index
          message={}
          message[:tranInvestors]=TranInvestor.all
          render json:{success: true,message: message}, status: :ok
        end   
        
        def get_tran_invest_amount_by_team
          tranInvestByTeams = TranInvestor.group(:team_event_id, 'teams.id', 'teams.name')
          .select('teams.id AS team_id, teams.name AS team_name, tran_investors.team_event_id AS team_event_id, SUM(tran_investors.amount) AS total_amount')
          .joins(team_event: :team)
          .pluck('teams.id AS team_id, teams.name AS team_name, tran_investors.team_event_id AS team_event_id, SUM(tran_investors.amount) AS total_amount')

          message={}
          message[:tranInvestByTeams]=tranInvestByTeams
          render json: {success: true,message: message}, status: :ok
        end
        def create
          result=@service.create()
          if result[:tranInvestor].present?
            message={}
            message[:tranInvestor]=result[:tranInvestor]
            render json: {success: true,message: message}, status: :created
          else
            render json: { errors: result[:errors] }, status: :unprocessable_entity
          end
        end

        private
        def member_params
          params.require(:tran_investor).permit(:desc,:team_id,:event_id,:judge_id)
        end
        def set_service
          @service = TranInvestor::CreateService.new(member_params)
        end
        

      end

    end
  end
  