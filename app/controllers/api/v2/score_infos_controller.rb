# app/controllers/api/v1/members_controller.rb

module Api
    module V2
      class ScoreInfosController < ApplicationController

        before_action :set_service, only: [:create]
        def index
          message={}
          message[:scoreInfos]=ScoreInfo.all
          render json:{success: true,message: message}, status: :ok

        end
        def create
          result=@service.create()
          if result[:scoreInfo].present?
            message={}
            message[:scoreInfo]=result[:scoreInfo]
            render json: {success: true,message: message}, status: :created
          else
            render json: { errors: scoreInfo[:errors] }, status: :unprocessable_entity
          end
        end

        private
        def member_params
          params.require(:score_info).permit(:name, :desc)
        end
        def set_service
          @service = ScoreInfo::CreateService.new(member_params)
        end


      end

    end
  end
