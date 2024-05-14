# app/controllers/api/v1/members_controller.rb
require 'active_model_serializers'
module Api
    module V2
      class TranScoresController < ApplicationController
        before_action :set_service, only: [:create]
        def index
          message={}
          message[:tranScores]=TranScore.all
          render json:{success: true,message: message}, status: :ok
        end

        def get_tran_score_by_judge_id
          latest_tran_score = TranScore.where(judge_id: params[:judge_id]).order(created_at: :desc).first
          message={}
          message[:tranScore] = latest_tran_score
          render json: {success: true, message: message}, status: :ok
        end

        def get_teams_total_score
          teams = Team.where(event_id: params[:event_id])
          judges= Judge.where(event_id: params[:event_id])
          teams.each do |team|
              total_score=0
              team_event = team.team_events.first
              next unless team_event
               ScoreMatrix.where(event_id: params[:event_id]).each do |score_matrix|
                    judges.each do |judge|
                        tran_scores = TranScore.where(team_event_id: team_event.id, score_matrix_id: score_matrix.id,judge_id: judge.id)
                        next unless tran_scores.any?
                        total_score+= tran_scores.last.score * score_matrix.weight
                    end
                end
                team_event.total_score=total_score/judges.length
                team_event.save
          end
          render json: teams, each_serializer: TeamSerializer
        end

        def get_teams_score_by_category
          teams = Team.where(event_id: params[:event_id])
          teams_data = {}
          ScoreMatrix.where(event_id: params[:event_id]).each do |score_matrix|
          Judge.where(event_id: params[:event_id]).each do |judge|
            teams.each do |team|
              team_event = team.team_events.first
              next unless team_event
                tran_scores = TranScore.where(team_event_id: team_event.id, score_matrix_id: score_matrix.id,judge_id: judge.member.id )
                next unless tran_scores.any?
                weighted_score = tran_scores.last.score * score_matrix.weight
                team_event.total_score ||= 0
                team_event.total_score += weighted_score
            end
          end
          teams_data[team.id] ||= team.as_json(only: [:id, :event_id, :active, :desc, :name, :pitching_order, :website_link, :team_event])
          teams_data[team.id][:score_category] ||= []
          teams_data[team.id][:score_category] << { category: score_matrix.name, score: weighted_score }

          end
          render json: teams_data.values
        end

        def create
          result=@service.create()
          if result[:tranScore]
            message={}
            message[:tranScore] = result[:tranScore]
            render json: {success: true, errors: message}, status: :created
          else
            render json: {success: false, errors: result[:errors] }, status: :ok
          end
        end

        private
        def member_params
          params.require(:tran_score).permit(:desc,:team_id,:event_id,:judge_id,:score_matrix_id,:score)
        end
        def set_service
          @service = TranScore::CreateService.new(member_params)
        end




      end

    end
  end
