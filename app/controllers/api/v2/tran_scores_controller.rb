# app/controllers/api/v1/members_controller.rb
require 'active_model_serializers'
module Api
    module V2
      class TranScoresController < ApplicationController

        before_action :set_service, only: [:create]
        before_action :set_event_id, only: [
          :get_teams_total_score,
          :get_teams_score_by_category
        ]
        before_action :set_event_member_id, only: [
          :get_all_team_score_categories_by_judge
        ]
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
          # authorize current_user, :call_test?
          service =TranScore::FetchTotalScoresService.new(@event_id)
          teams=service.call
          render json: {success: true, message: { teams: teams}}, status: :ok
        end

        def get_teams_score_by_category
          service =TranScore::FetchTeamScoresByCategoryService.new(@event_id)
          teams=service.call
          render json: {success: true, message: { teams: teams}}, status: :ok
        end

        def get_all_team_score_categories_by_judge
          # @user=User.find_by(member_id: @member_id)
          # authorize @user, :call_test_owner?
          service=TranScore::FetchAllTeamScoreCategoriesByJudge.new(@event_id,@member_id)
          teams_data=service.call
          if !teams_data[:error]
             render json: { success: true, message: { teams: teams_data[:teams] } }, status: :ok
          else
             render json: { success: false, message: { error: teams_data[:error]} }, status: :not_found
          end
        end

        def get_one_team_score_categories_by_all_judges
          service = TranScore::FetchOneTeamScoreCategoriesByAllJudges.new(params[:event_id], params[:team_id])
          result = service.get_one_team_score_categories_by_all_judges
          if result[:success]
            render json: result, status: :ok
          else
            render json: result, status: :not_found
          end
        end

        def get_one_team_score_category_by_individual_judge
          service = TranScore::FetchOneTeamScoreCategoryByIndividualJudge.new(params[:event_id], params[:team_id])
          result = service.get_one_team_score_category_by_individual_judge
          if result[:success]
            render json: result, status: :ok
          else
            render json: result, status: :not_found
          end
        end


        def get_all_tran_score_by_all_judges
          judges = Judge.includes(:member).where(event_id: params[:event_id])
          if judges.empty?
            render json: { success: false, error: "No Judge found" }, status: :not_found and return
          end

          judges_data = judges.map do |judge|
            member_data = judge.member.as_json
            tran_scores = TranScore.includes(:team_event,:score_matrix)
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
        def set_event_id
          @event_id = params[:event_id]
        end
        def set_event_member_id
          @event_id = params[:event_id]
          @member_id= params[:member_id]
        end


        end

    end
  end
