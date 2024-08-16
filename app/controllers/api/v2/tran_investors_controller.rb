# app/controllers/api/v1/members_controller.rb
require 'active_model_serializers'
module Api
    module V2
      class TranInvestorsController < ApplicationController
        before_action :set_service, only: [:create]
        def index
          message={}
          message[:tranInvestors]=TranInvestor.all
          render json:{success: true,message: message}, status: :ok
        end

        def get_all_tran_investors_by_event
          message=TranInvestor::FetchTranInvestorService.new().fetch_all_tran_investors_by_event(params[:event_id])
          render json: message, status: :ok
        end

        def get_all_tran_investors_by_event_and_judge
          message=TranInvestor::FetchTranInvestorService.new().fetch_all_tran_investors_by_event_and_judge(params[:event_id],params[:member_id])
          render json: message, status: :ok
        end

        def invest_amounts_by_team()
          message=TranInvestor::FetchTranInvestorService.new().fetch_invest_amounts_by_team(params[:event_id])
          render json: message, status: :ok
        end

        def create

          result=@service.create()
          if result[:tranInvestor].present?
            message={}
            render json: {success: true, errors: message}, status: :created
          else
            render json: {success: false, errors: result[:errors] }, status: :ok
          end
        end

        private
        def member_params
          params.require(:tran_investor).permit(:desc,:team_id,:event_id,:judge_id,:tran_type,:investor_type)
        end
        def set_service
          @service = TranInvestor::CreateService.new(member_params)
        end


      end

    end
  end
