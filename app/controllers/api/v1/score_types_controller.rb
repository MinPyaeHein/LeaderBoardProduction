# app/controllers/api/v1/members_controller.rb

module Api
    module V1
      class ScoreTypesController < ApplicationController
        before_action :set_service, only: [:create]
        def index
          render json:ScoreType.all
          
        end

       
        def create
          
         
          @service =@service.create()
          if @service 
            render json: @service, status: :created
          else
            render json: { errors: @service.create_event_type.errors.full_messages }, status: :unprocessable_entity
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
  