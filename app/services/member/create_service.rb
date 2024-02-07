# app/services/member_service.rb


    class Member::CreateService
      def initialize(params)
        @params = params
      end
      
  
      def create_member
        username, domain = @params[:email].split("@")
        member = ::Member.create(name: username, address: @params[:address], desc: @params[:desc])
        begin
          password = SecureRandom.hex(8)
          bcPassword = BCrypt::Password.create(password)
          user = User.new(email: @params[:email], encrypted_password: bcPassword, password_digest: bcPassword, member_id: member.id)
        
          if user.save
            token = user.generate_jwt
            user.update(reset_password_token: token)
            { user: user, member: member, token: token, password: password }
          else
            { errors: user.errors.full_messages }
          end
        rescue ActiveRecord::RecordNotUnique => e
          { errors: ["Email address is already taken"] }
        end
      end
      
      def destroy_member(member_id)
        member = ::Member.find_by(id: member_id)
  
        if member.present?
          member.update(active: false)
          member.users.update_all(active: false)
          { message: 'Member and associated users deactivated successfully', status: :ok }
        else
          { message: 'Member not found', status: :not_found }
        end
      end

      private

      def send_password_email(member, password, user)
        MemberMailer.welcome_email(member, user, password).deliver_now
      end
    end

  