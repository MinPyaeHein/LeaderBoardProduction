# app/controllers/api/v1/members_controller.rb

module Api
    module V1
      class FacultiesController < ApplicationController
        before_action :set_service, only: [:create]
        def index
          render json:Faculty.all
          
        end

       
        def create
          result =@service.create()
          message={}
          if result[:faculty].present?
            message[:faculty] = result[:faculty]
            render json: message, status: :created
          else
            message[:errors]=result[:errors]
            render json: message, status: :unprocessable_entity
          end
        end

        private
        def faculty_params
          params.require(:faculty).permit(:name, :desc)
        end
        def set_service
          @service = Faculty::CreateService.new(faculty_params)
        end

      end
    end
  end
  