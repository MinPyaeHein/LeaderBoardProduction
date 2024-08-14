# app/controllers/api/v1/members_controller.rb
require 'active_model_serializers'
module Api
    module V2
      class JudgesController < ApplicationController
        before_action :set_service, only: [:create]
        def index
          @judges = Judge.where(active: true)
          message={}
          message[:judges]=@judges
          render json: {success: true,message: message}
        end

        def create
          filtered_params = judge_params.except(:member_ids)
          @judge = Judge.new(filtered_params)
          authorize @judge
          result=@service.create()
          if result.present?
            render json:{success: true,message: result}, status: :created
          end
        end


        def get_judge_by_event_id_and_judge_id
          service=Judge::FetchTeamAmountInvestedByOneJudgeInEvent.new(params[:member_id],params[:event_id])
          message=service.perform()
          render json:{success: true, message: message}
        end




        def get_judges_by_event_id
          event_id = params[:event_id]
          judges=Judge.where(event_id: event_id)
          serialized_judges = ActiveModelSerializers::SerializableResource.new(judges, each_serializer: JudgeSerializer)
          message = {
            judges: serialized_judges
          }
          render json: { success: true, message: message }
        end
        private
        def judge_params
          params.require(:judge).permit(:judge_type,:event_id ,:judge_id,:active, :current_amount, member_ids: [])
        end

        def set_service
          @service = Judge::CreateService.new(judge_params)


        end

      end
    end
  end
