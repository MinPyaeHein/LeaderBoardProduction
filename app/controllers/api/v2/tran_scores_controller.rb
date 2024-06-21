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
          teams.each do |team|
            weighted_score=0;
            team_event = team.team_events.first
              Judge.where(event_id: params[:event_id]).each do |judge|
                    tran_scores = TranScore.where(team_event_id: team_event.id, score_matrix_id: score_matrix.id,judge_id: judge.id )
                    next unless tran_scores.any?
                    last_tran_score = tran_scores.last
                    next unless last_tran_score
                    weighted_score += last_tran_score.score * score_matrix.weight
              end
              teams_data[team.id] ||= team.as_json(only: [:id, :event_id, :active, :desc, :name, :pitching_order, :website_link, :team_event])
              teams_data[team.id][:score_category] ||= []
              teams_data[team.id][:score_category] << { category: score_matrix.name, score: weighted_score }
            end
          end
          render json: teams_data.values
        end

        def get_all_teams_score_categories_by_judge
          teams = Team.where(event_id: params[:event_id])
          judge = Judge.where(member_id: params[:member_id],event_id: params[:event_id])
          if teams.nil?
            render json: {success: false,  error: "Teams not found" }, status: :not_found and return
          end

          if judge.nil?
            render json: {success: false,  error: "Judge not found" }, status: :not_found and return
          end
          teams_data = {}
          ScoreMatrix.where(event_id: params[:event_id]).each do |score_matrix|
          teams.each do |team|
            weighted_score=0;
            team_event = team.team_events.first
                    tran_scores = TranScore.where(team_event_id: team_event.id, score_matrix_id: score_matrix.id,judge_id: judge.last.id )
                    next unless tran_scores.any?
                    last_tran_score = tran_scores.last
                    next unless last_tran_score
                    weighted_score += last_tran_score.score * score_matrix.weight
              teams_data[team.id] ||= team.as_json(only: [:id, :event_id, :active, :desc, :name, :pitching_order, :website_link, :team_event])
              teams_data[team.id][:score_category] ||= []
              teams_data[team.id][:score_category] << { category: score_matrix.name, score: weighted_score }
            end
          end
          render json: teams_data.values
        end

        def get_one_team_score_categories_by_all_judges
          teams= Team.where(event_id: params[:event_id],id: params[:team_id])
          teams_data = {}
          ScoreMatrix.where(event_id: params[:event_id]).each do |score_matrix|
            if teams.nil?
              render json: { success: false, error: "Teams not found" }, status: :not_found and return
            end
            weighted_score=0;
            team_event = teams.last.team_events.last
              Judge.where(event_id: params[:event_id]).each do |judge|
                    tran_scores = TranScore.where(team_event_id: team_event.id, score_matrix_id: score_matrix.id,judge_id: judge.id )
                    next unless tran_scores.any?
                    last_tran_score = tran_scores.last
                    next unless last_tran_score
                    weighted_score += last_tran_score.score * score_matrix.weight
              end
              teams_data[teams.last.id] ||= teams.last.as_json(only: [:id, :event_id, :active, :desc, :name, :pitching_order, :website_link, :team_event])
              teams_data[teams.last.id][:score_category] ||= []
              teams_data[teams.last.id][:score_category] << { category: score_matrix.name, score: weighted_score }
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
        def score_team_by_all_categories
          event_id = params[:event_id]
          judge_id = params[:judge_id]
          team_id = params[:team_id]
          tran_scores = params[:tran_score]

          # Validate the presence of the required parameters
          if event_id.nil? || judge_id.nil? || team_id.nil? || tran_scores.nil? || !tran_scores.is_a?(Array)
            render json: { success: false, errors: "Missing or invalid parameters" }, status: :unprocessable_entity and return
          end

          # Prepare the data for the service
          tran_scores_data = tran_scores.map do |tran_score|
            {
              score: tran_score[:score],
              score_matrix_id: tran_score[:score_matrix_id],
              desc: tran_score[:desc]
            }
          end

          result=@service.create_with_categories()
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
