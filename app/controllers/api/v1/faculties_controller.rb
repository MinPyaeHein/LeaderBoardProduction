# app/controllers/api/v1/members_controller.rb

module Api
    module V1
      class FacultiesController < ApplicationController
        skip_before_action :authenticate_request, only: [:create, :index]
        before_action :set_service, only: [:create]
        def index
          message={}
          message[:faculties]=Faculty.all
          render json:{success: true,message: message}, status: :ok
          
        end

       
        def create
          result =@service.create()
          message={}
          if result[:faculty].present?
            message[:faculty] = result[:faculty]
            render json: { success: true,message: message}, status: :created
          else
            message[:errors]=result[:errors]
            render json:{success: false,message: message}, status: :unprocessable_entity
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
  