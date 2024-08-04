# app/controllers/api/v1/members_controller.rb

module Api
    module V2
      class ScoreMatricesController < ApplicationController

        before_action :set_service, only: [:create]
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
          # authorize current_user, :editor_or_owner?(params[:event_id])
          result=@service.createScoreMatrics
          message={}
          message[:scoreMatrics]=result
          render json: {success: true,message: message}, status: :created
        end

        private
        def score_matrix_params
          params.require(:score_matrics)
        end

        def set_service
          @service = ScoreMatrix::CreateService.new(score_matrix_params)
        end


      end

    end
  end
