# app/services/member_service.rb


    class Member::DestroyService
      def initialize(member_id)
        @member_id = member_id
      end
      
  
      
      def destroy_member()
        member = ::Member.find_by(id: @member_id)
        if member.present?
          member.update(active: false)
          member.users.update_all(active: false)
          { message: 'Member and associated users deactivated successfully', status: :ok }
        else
          { message: 'Member not found', status: :not_found }
        end
      end

      
    end

  