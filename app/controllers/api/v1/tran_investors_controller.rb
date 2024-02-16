# app/controllers/api/v1/members_controller.rb

module Api
    module V1
      class TranInvestorsController < ApplicationController
        before_action :set_service, only: [:create]
        def index
          message={}
          message[:tranInvestors]=TranInvestor.all
          render json:{success: true,message: message}, status: :ok
        end       
        def create
          result=@service.create()
          if result[:tranInvestor].present?
            message={}
            message[:tranInvestor]=result[:tranInvestor]
            render json: {success: true,message: message}, status: :created
          else
            render json: { errors: result[:errors] }, status: :unprocessable_entity
          end
        end

        private
        def member_params
          params.require(:tran_investor).permit(:desc,:team_id,:event_id,:judge_id)
        end
        def set_service
          @service = TranInvestor::CreateService.new(member_params)
        end
        

      end

    end
  end
  