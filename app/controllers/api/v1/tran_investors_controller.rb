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
        
        def invest_amounts_by_team()
          event_id = params[:event_id]
          teamInvestScores = TranInvestor.group(:team_event_id, 'teams.id', 'team_events.event_id')
                                          .select('teams.id AS team_id, team_events.event_id, 
                                          tran_investors.team_event_id AS team_event_id, 
                                          SUM(tran_investors.amount) AS total_amount')
                                          .joins(team_event: :team)
                                          .where(team_events: { event_id: event_id })
                                          .pluck('teams.id AS team_id, teams.name AS team_name,
                                           tran_investors.team_event_id AS team_event_id, 
                                           SUM(tran_investors.amount) AS total_amount, 
                                           team_events.event_id')
        
          # Modify each object in tranInvestByTeams to include "name" and "value" attributes
          teamInvestScores.map! do |team|
            {
              name: team[1],
              value: team[3],
              team_id: team[0],
              team_event_id: team[2],
              event_id: team[4]
            }
          end
        
          message = { teamInvestScores: teamInvestScores }
          render json: { success: true, message: message }, status: :ok
        end
        def create

          result=@service.create()
          if result[:tranInvestor].present?
            message={}
            message[:tranInvestor]=result[:tranInvestor]
            message[:judge]=result[:judge]
            render json: {success: true,message: message}, status: :created
          else
            render json: {success: false, errors: result[:errors] }, status: :ok
          end
        end

        private
        def member_params
          params.require(:tran_investor).permit(:desc,:team_id,:event_id,:judge_id)
        end
        def set_service
          puts "set_service----member_params ==#{member_params}"
          @service = TranInvestor::CreateService.new(member_params)
        end
        

      end

    end
  end
  