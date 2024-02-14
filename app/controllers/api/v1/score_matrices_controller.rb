# app/controllers/api/v1/members_controller.rb

module Api
    module V1
      class ScoreMatricesController < ApplicationController
       
        before_action :set_service, only: [:create]
        def index
          message={}
          message[:scoreMatrics]=ScoreMatrix.all
          render json:{success: true,message: message}, status: :ok
          
        end       
        def create
          result=@service.create()
          if result[:scoreMatrix].present?
            message={}
            message[:scoreMatrix]=result[:scoreMatrix]
            render json: {success: true,message: message}, status: :created
          else
            render json: { errors: result[:errors] }, status: :unprocessable_entity
          end
        end

        private
        def member_params
          params.require(:score_matrix).permit(:weight, :max,:min,:event_id,:score_info_id)
        end
        def set_service
          @service = ScoreMatrix::CreateService.new(member_params)
        end
        

      end

    end
  end
  