# app/controllers/api/v1/members_controller.rb

module Api
    module V2
      class ScoreMatricesController < ApplicationController

        before_action :set_service, only: [:create,:update]
        def index
          message={}
          message[:scoreMatrics]=ScoreMatrix.all
          render json:{success: true,message: message}, status: :ok

        end

        def get_score_matrix_by_event_id
          message={}
          scoreMatrics=ScoreMatrix.where(event_id: params[:event_id])
          serialized_scoreMatrcs = ActiveModelSerializers::SerializableResource.new(scoreMatrics, each_serializer: ScoreMatrixSerializer)
          message[:scoreMatrics]=serialized_scoreMatrcs
          render json:{success: true,message: message}, status: :ok
        end

        def create
          filtered_params = score_matrix_params.first.except(:shortTerm)
          authorize ScoreMatrix.new(filtered_params)
          message=@service.createScoreMatrices
          render json: message, status: :created
        end

        def update
          message=@updateService.updateScoreMatrices
          render json: message, status: :created
        end

        private
        def score_matrix_params
          params.require(:score_matrices)
                .map { |matrix| matrix.permit(:weight, :max, :min, :event_id, :name, :shortTerm ,:id) }
        end

        def set_service
          @service = ScoreMatrix::CreateService.new(score_matrix_params)
          @updateService=ScoreMatrix::UpdateService.new(score_matrix_params)
        end


      end

    end
  end
