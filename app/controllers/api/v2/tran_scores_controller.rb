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
