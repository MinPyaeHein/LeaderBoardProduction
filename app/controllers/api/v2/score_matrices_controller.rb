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
        def create
          result=@service.createScoreMatrics
          puts("result=",result)
          message={}
          message[:scoreMatrics]=result
          render json: {success: true,message: message}, status: :created
        end

        private
        def member_params
          params[:score_matrics]
        end
        def set_service
          @service = ScoreMatrix::CreateService.new(member_params)
        end


      end

    end
  end
