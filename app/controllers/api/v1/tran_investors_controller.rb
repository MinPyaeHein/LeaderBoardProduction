# app/controllers/api/v1/members_controller.rb
require 'active_model_serializers'
module Api
    module V1
      class TranInvestorsController < ApplicationController
        before_action :set_service, only: [:create]
        def index
          message={}
          message[:tranInvestors]=TranInvestor.all
          render json:{success: true,message: message}, status: :ok
        end   

        def get_all_tran_investors_by_event
          event_id=params[:event_id]
          judges_origin=Judge.includes(:member).where(event_id:event_id)
          judges= []
          judges_origin.each do |judge|
            tran_investors = TranInvestor.includes(:team_event).where(event_id:event_id,judge_id:judge.id)
            serialized_tran_investors = ActiveModelSerializers::SerializableResource.new(tran_investors, each_serializer: TranInvestorSerializer)
            judge = {
              id: judge.id,
              name: judge.member.name, 
              event_id: judge.event_id,
              tran_investors: serialized_tran_investors
            }
            judges << judge
          end
          message = { judges: judges}
          render json: { success: true, message: message }, status: :ok
        end

        def invest_amounts_by_team()
          event_id = params[:event_id]
          teamInvestScores = TranInvestor.group(:team_event_id, 'teams.id', 'team_events.event_id')
                                          .select('teams.id AS team_id, team_events.event_id, 
                                          tran_investors.team_event_id AS team_event_id,teams.pitching_order
                                          SUM(tran_investors.amount) AS total_amount')
                                          .joins(team_event: :team)
                                          .where(team_events: { event_id: event_id })
                                          .pluck('teams.id AS team_id, teams.name AS team_name,
                                           tran_investors.team_event_id AS team_event_id, 
                                           SUM(tran_investors.amount) AS total_amount, 
                                           team_events.event_id,teams.pitching_order')
        
         
          teamInvestScores.map! do |team|
            print "team: #{team[0]} #{team[1]} #{team[2]} #{team[3]} #{team[4]} #{team[5]}"
            {
              name: team[1],
              value: team[3],
              team_id: team[0],
              team_event_id: team[2],
              team_pitching_order: team[5],
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
            render json: {success: true, errors: message}, status: :created
          else
            render json: {success: false, errors: result[:errors] }, status: :ok
          end
        end

        private
        def member_params
          params.require(:tran_investor).permit(:desc,:team_id,:event_id,:judge_id,:tran_type,:investor_type)
        end
        def set_service
          @service = TranInvestor::CreateService.new(member_params)
        end
        

      end

    end
  end
  