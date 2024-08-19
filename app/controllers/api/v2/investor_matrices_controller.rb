# app/controllers/api/v1/members_controller.rb

module Api
    module V2
      class InvestorMatricesController < ApplicationController
        before_action :set_service, only: [:create]
        def index
          message={}
          message[:investorMatrics]=InvestorMatrix.all
          render json:{success: true,message: message}, status: :ok
        end
        def create
          @investor_matrix = InvestorMatrix.new(member_params)
          # authorize @investor_matrix
          result=@service.create()
          if result[:investorMatrix].present?
            message={}
            message[:investorMatrix]=result[:investorMatrix]
            render json: {success: true,message: message}, status: :created
          else
            render json: { errors: result[:errors] }, status: :unprocessable_entity
          end
        end

        private
        def member_params
          params.require(:investor_matrix).permit(:total_amount,:one_time_pay,:event_id,:judge_acc_amount,:investor_type)
        end
        def set_service
          @service = InvestorMatrix::CreateService.new(member_params)
        end


      end

    end
  end
