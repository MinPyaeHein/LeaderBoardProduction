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
        def get_editors_by_event_id
          event_id = params[:event_id] # Assuming you're passing event_id as a parameter
          # Fetching judges associated with the given event for the specified team
          members = Member.joins(:editors)
                         .where('editors.event_id = ?', event_id)
                         .select('editors.*') # Selecting only judge attributes
          puts "members #{members}"
          # members = judges.map(&:member)
          message={}
          
          message[:editors]=members
          render json: {success: true,message: message}
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
  