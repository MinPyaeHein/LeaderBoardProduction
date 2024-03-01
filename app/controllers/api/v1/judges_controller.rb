# app/controllers/api/v1/members_controller.rb

module Api
    module V1
      class JudgesController < ApplicationController
        before_action :set_service, only: [:create]
        def index
          @judges = Judge.where(active: true)
          message={}
          message[:judges]=@judges
         
          render json: {success: true,message: message}
        end
      
        def create 
          result=@service.create()
          message={}
          if result.present?
            message[:judges] = result[:judges]
            message[:errors] = result[:errors]
            render json:{success: true,message: message}, status: :created
          end
        end
        def get_judge_by_id
          params=judge_params
          teamInvestScores = TranInvestor.group(:team_event_id, 'teams.id', 'team_events.event_id')
          .select('teams.id AS team_id, teams.name AS team_name, team_events.event_id, SUM(tran_investors.amount) AS total_amount')
          .joins(team_event: :team)
          .where(team_events: { event_id: params[:event_id] }, tran_investors: { judge_id: params[:judge_id] })
          .pluck('teams.id AS team_id, teams.name AS team_name, tran_investors.team_event_id AS team_event_id, SUM(tran_investors.amount) AS total_amount, team_events.event_id') 
         
          judge = Judge.find(params[:judge_id])
          member = Member.find(params[:judge_id])
          teams_under_event = Team.joins(:team_events).where(team_events: { event_id: params[:event_id] })
          puts "teams_under_event #{teams_under_event.first.name}"
          message = {}
          message[:judge] = judge
          message[:member] = member
            teams_under_event.each do |team|              
                unless teamInvestScores.any? { |score|  score[:team_id] == team.id }
                  teamInvestScores << {
                    team_id: team.id,
                    team_name: team.name,
                    total_amount: 0.0  
                  }
                end
            end
            message[:teamInvestScores] = teamInvestScores
            render json: {success: true,message: message}
         

          end
         
         def get_judges_by_event_id
          event_id = params[:event_id] # Assuming you're passing event_id as a parameter         
          # Fetching judges associated with the given event for the specified team
          members = Member.joins(:judges)
                         .where('judges.event_id = ?', event_id)
                         .select('judges.*') # Selecting only judge attributes
         
          message={}   
          message[:judges]=members
          render json: {success: true,message: message}
        end
        private
        def judge_params
          params.require(:judge).permit(:event_id ,:judge_id,:active, :current_amount, member_ids: [])
        end
        
        def set_service
          @service = Judge::CreateService.new(judge_params)
       
         
        end

      end
    end
  end
  