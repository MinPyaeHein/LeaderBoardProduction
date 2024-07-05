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
                              if tran_scores.any?
                              total_score+= tran_scores.last.score * score_matrix.weight
                              end
                          end
                    end

                team_event.total_score=total_score/judges.length
                team_event.save

          end

          message={}
          message[:teams]=teams
          render json: {success: true,message:message}, each_serializer: TeamSerializer
        end

        def get_teams_score_by_category
          teams = Team.where(event_id: params[:event_id])

          if teams.empty?
            render json: { success: false, error: "Teams not found" }, status: :not_found and return
          end

          teams_data = []
          score_matrics = ScoreMatrix.includes(:score_info).where(event_id: params[:event_id])
          judges = Judge.where(event_id: params[:event_id])
          teams.each do |team|
            weighted_scores = Hash.new(0)  # Initialize scores for all categories to 0
            team_event = team.team_events.first

            judge_count=0
            judges.each do |judge|
              total_score_judge=0
              score_matrics.each do |score_matrix|
                  tran_scores = TranScore.where(team_event_id: team_event.id, score_matrix_id: score_matrix.id, judge_id: judge.id)
                  if tran_scores.any?
                    last_tran_score = tran_scores.last
                    weighted_scores[score_matrix.name] += last_tran_score.score * score_matrix.weight if last_tran_score
                    total_score_judge+=last_tran_score.score * score_matrix.weight if last_tran_score
                  end
                end
                if total_score_judge==0
                  judge_count+=1
                end
            end

            team_data = team.as_json(only: [:id, :event_id, :active, :desc, :name, :pitching_order, :website_link])
            total_score = 0
            team_data[:score_category] = score_matrics.map do |score_matrix|
              score = (judges.length-judge_count) >0 ? (weighted_scores[score_matrix.name] / (judges.length-judge_count)) : 0
              formatted_score = score.zero? ? 0 : score.round(2)
              total_score += formatted_score
              {
                category: score_matrix.name,
                short_term: score_matrix.score_info.shortTerm,
                score: formatted_score
              }
            end
            team_data[:total_score] = total_score.round(2)
            teams_data << team_data
          end

          render json: { success: true, message: { teams: teams_data } }, status: :ok
        end

        def get_all_teams_score_categories_by_judge
          teams = Team.where(event_id: params[:event_id])
          judge = Judge.where(member_id: params[:member_id], event_id: params[:event_id])

          if teams.empty?
            render json: { success: false, error: "Teams not found" }, status: :not_found and return
          end

          if judge.empty?
            render json: { success: false, error: "Judge not found" }, status: :not_found and return
          end

          teams_data = []
          score_matrics = ScoreMatrix.includes(:score_info).where(event_id: params[:event_id])

          teams.each do |team|
            team_event = team.team_events.first
            next if team_event.nil?

            weighted_scores = Hash.new(0)
            scores = Hash.new(0)

            score_matrics.each do |score_matrix|
              tran_scores = TranScore.where(team_event_id: team_event.id, score_matrix_id: score_matrix.id, judge_id: judge.last.id)

              if tran_scores.any?
                last_tran_score = tran_scores.last
                weighted_scores[score_matrix.name] = last_tran_score.score * score_matrix.weight
                scores[score_matrix.name] = last_tran_score.score
              end
            end

            team_data = team.as_json(only: [:id, :event_id, :active, :desc, :name, :pitching_order, :website_link, :team_event])
            team_data[:score_category] = score_matrics.map do |score_matrix|
              { category: score_matrix.name, weighted_scores: weighted_scores[score_matrix.name], scores: scores[score_matrix.name], short_term: score_matrix.score_info.shortTerm }
            end
            teams_data << team_data
          end

          render json: { success: true, message: { teams: teams_data } }, status: :ok
        end
        def get_one_team_score_categories_by_all_judges
          teams = Team.where(event_id: params[:event_id], id: params[:team_id])
          if teams.empty?
            render json: { success: false, error: "Team not found" }, status: :not_found and return
          end
          team = teams.last
          team_data = team.as_json(only: [:id, :event_id, :active, :desc, :name, :pitching_order, :website_link])
          team_data[:score_category] = []

          judges = Judge.where(event_id: params[:event_id])
          score_matrices = ScoreMatrix.includes(:score_info).where(event_id: params[:event_id])

          score_matrices.each do |score_matrix|
            weighted_score = 0
            team_event = team.team_events.last
            valid_judge_count = 0

            judges.each do |judge|
              tran_scores = TranScore.where(team_event_id: team_event.id, score_matrix_id: score_matrix.id, judge_id: judge.id)
              if tran_scores.any?
                last_tran_score = tran_scores.last
                if last_tran_score && last_tran_score.score > 0
                  weighted_score += last_tran_score.score * score_matrix.weight
                  valid_judge_count += 1
                end
              end
            end

            score = valid_judge_count > 0 ? (weighted_score / valid_judge_count) : 0
            formatted_score = score.zero? ? 0 : score.round(2)
            team_data[:score_category] << { category: score_matrix.name, score: formatted_score, short_term: score_matrix.score_info.shortTerm }
          end

          render json: { success: true, message: { team: team_data } }, status: :ok
        end

        def get_one_team_score_category_by_individual_judge
          teams = Team.where(event_id: params[:event_id], id: params[:team_id])
          if teams.empty?
            render json: { success: false, error: "Team not found" }, status: :not_found and return
          end

          team = teams.last
          team_data = team.as_json(only: [:id, :event_id, :active, :desc, :name, :pitching_order, :website_link])
          team_data[:judges] = []
          score_matrics = ScoreMatrix.includes(:score_info).where(event_id: params[:event_id])

          Judge.where(event_id: params[:event_id]).each do |judge|
            score_category = []
            score_matrics.each do |score_matrix|
              team_event = team.team_events.last
              if team_event.nil?
                score_category << { category: score_matrix.name, score: 0, short_term: score_matrix.score_info.shortTerm, weight: score_matrix.weight }
                next
              end

              tran_scores = TranScore.where(team_event_id: team_event.id, score_matrix_id: score_matrix.id, judge_id: judge.id)
              if tran_scores.any?
                last_tran_score = tran_scores.last
                score_category << { category: score_matrix.name, score: last_tran_score.score, short_term: score_matrix.score_info.shortTerm, weight: score_matrix.weight }
              else
                score_category << { category: score_matrix.name, score: 0, short_term: score_matrix.score_info.shortTerm, weight: score_matrix.weight }
              end
            end

            judge_name = judge.member&.name || "Unknown Judge"
            team_data[:judges] << { id: judge.id, member_id: judge.member_id, name: judge_name, score_categories: score_category }
          end

          render json: { success: true, message: { team: team_data } }, status: :ok
        end


        def get_all_teams_score_category_by_individual_judges
          teams = Team.where(event_id: params[:event_id])
          if teams.empty?
            render json: { success: false, error: "No teams found" }, status: :not_found and return
          end

          all_teams_data = []
          score_matrics = ScoreMatrix.includes(:score_info).where(event_id: params[:event_id])
          judges = Judge.where(event_id: params[:event_id])

          teams.each do |team|
            team_data = team.as_json(only: [:id, :event_id, :active, :desc, :name, :pitching_order, :website_link])
            team_data[:judges] = []

            judges.each do |judge|
              score_category = []
              score_matrics.each do |score_matrix|
                team_event = team.team_events.last
                if team_event.nil?
                  score_category << { category: score_matrix.name, score: 0, short_term: score_matrix.score_info.shortTerm, weight: score_matrix.weight }
                  next
                end

                tran_scores = TranScore.where(team_event_id: team_event.id, score_matrix_id: score_matrix.id, judge_id: judge.id)
                if tran_scores.any?
                  last_tran_score = tran_scores.last
                  score_category << { category: score_matrix.name, score: last_tran_score.score, short_term: score_matrix.score_info.shortTerm, weight: score_matrix.weight }
                else
                  score_category << { category: score_matrix.name, score: 0, short_term: score_matrix.score_info.shortTerm, weight: score_matrix.weight }
                end
              end

              judge_name = judge.member&.name || "Unknown Judge"
              team_data[:judges] << { id: judge.id, member_id: judge.member_id, name: judge_name, score_categories: score_category }
            end

            all_teams_data << team_data
          end

          render json: { success: true, message: { teams: all_teams_data } }, status: :ok
        end


        def get_all_tran_score_by_all_judges
          judges = Judge.includes(:member).where(event_id: params[:event_id])
          if judges.empty?
            render json: { success: false, error: "No Judge found" }, status: :not_found and return
          end
          judges_data = judges.map do |judge|
            member_data = judge.member.as_json
            tran_scores = TranScore.includes(:score_matrix)
                                   .where(judge_id: judge.id, event_id: params[:event_id])
            serialized_tran_scores = ActiveModelSerializers::SerializableResource.new(tran_scores, each_serializer: TranScoreSerializer)
            member_data[:tran_scores] = serialized_tran_scores.as_json
            member_data
          end

          render json: { success: true, message: { judges_data: judges_data } }, status: :ok
        end

        def create
          result = @service.create()
          if result[:tranScores]
            message = {}
            message[:tranScores] = result[:tranScores]
            render json: { success: true, message: message }, status: :created
          else
            render json: { success: false, errors: result[:errors] }, status: :ok
          end
        end

        private
        def member_params
          params.require(:tran_score).permit(
            :event_id,
            :judge_id,
            :team_id,
            tran_score: [
              :desc,
              :score_matrix_id,
              :score
            ]
          )
        end

        def set_service
          @service = TranScore::CreateService.new(member_params)
        end



        end

    end
  end
