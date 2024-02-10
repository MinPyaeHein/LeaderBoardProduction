# app/controllers/api/v1/members_controller.rb

module Api
    module V1
      class EditorsController < ApplicationController
        before_action :set_service, only: [:create]
       
        def index
          @editors = Editor.where(active: true)
          message={}
          message[:success]=true
          message[:editors]=@editors
          render json: {message: message}
        end

       
       
        def create 
          result=@service.create()
          message={}
          if result[:editor].present?
            message[:success] = true
            message[:editor] = result[:editor]
            render json:{message: message}, status: :created
          else
            message[:success] = false
            message[:errors] = result[:errors]
            render json: { message: message }, status: :unprocessable_entity
  
          end
        end

        private
        def editor_params
          params.require(:editor).permit(:member_id,:event_id ,:active)
        end
        def set_service
          @service = Editor::CreateService.new(editor_params)
        end

      end
    end
  end
  