# app/controllers/api/v1/members_controller.rb

module Api
    module V1
      class EditorsController < ApplicationController
        before_action :set_service, only: [:create]
        def index
          @editors = Editor.where(active: true)
          message={}
          message[:editors]=@editors
          render json: {success: true,message: message}
        end

        def create 
          result=@service.create()
          
          message={}
          if result.present?
            message[:editors] = result[:editors]
            message[:errors] = result[:errors]
            render json:{message: message,success: true}, status: :created
          end
        end

        private
        def editor_params
          params.require(:editor).permit(:event_id, :active, member_ids: [])
        end
        def set_service
         
          @service = Editor::CreateService.new(editor_params)
        end
      

      end
    end
  end
  