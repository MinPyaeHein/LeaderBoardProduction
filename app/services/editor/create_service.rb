# app/services/member_service.rb
    class Editor::CreateService
      def initialize(params)
        @params = params
      end
      def create
        editors = []
        errors = []
      
        @params[:member_ids].each do |member_id|
          result = check_editor(member_id)
          if result[:errors].present?
            errors << result[:errors]
          else
            editor = ::Editor.create(
              member_id: member_id,
              event_id: @params[:event_id],
              active: @params[:active]
            ) 
            
            if editor.persisted?
              editors << editor
            else
              errors << editor.errors.full_messages
            end
          end
        end 
      
        { editors: editors, errors: errors }
      end
      
      def check_editor(id)
        member = Member.includes(:users).find_by(id: id, active: true)
        if member.nil? 
          return { errors: ["Member does not exist in the database."] }
        end
        editor = ::Editor.find_by(member_id: id, event_id: @params[:event_id], active: true)
        if !editor.nil?
          return { errors: ["This member is already editor in the part of the event!!"] }
        end
        {}
      end

    
    end

  