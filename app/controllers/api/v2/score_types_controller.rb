# app/controllers/api/v1/members_controller.rb

module Api
    module V2
      class ScoreTypesController < ApplicationController
        before_action :set_service, only: [:create]
        def index
          message={}
          message[:scoreTypes]=ScoreType.all
          render json: {success: true,message: message}, status: :ok
        end

        def create
          result =@service.create()
          message={}
          if result[:scoreType].present?
            
            message[:scoreType]=result[:scoreType]
            render json: { success: true,message: message}, status: :created
          else
            render json: {success: false ,errors: result[:errors] }, status: :unprocessable_entity
          end
        end

        private
        def score_type_params
          params.require(:score_type).permit(:name, :desc)
        end
        def set_service
          @service = ScoreType::CreateService.new(score_type_params)
        end

      end
    end
  end
