# app/services/member_service.rb
    class Editor::CreateService
      def initialize(params)
        @params = params
      end
      def create
        result=check_editor
        if result[:errors].present?
          return result
        end
        editor = ::Editor.create(
          member_id:  @params[:member_id],  
          event_id: @params[:event_id],
          active:  @params[:active]
          
        ) 
        if editor.save
       
          { editor: editor}
        else
          { errors: editor.errors.full_messages }
        end
      end
      def check_editor
        member = ::Member.find_by(id: @params[:member_id],active: true)
        unless member
          return { errors: ["Member with ID #{@params[:member_id]} does not exist in the database."] }
        end
        editor = ::Editor.find_by(member_id: @params[:member_id], event_id: @params[:event_id], active: true)
        if editor.present?
          return { errors: ["This member is already editor in the part of the event!!"] }
        end
        {}
      end

    
    end

  