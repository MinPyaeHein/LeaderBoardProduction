# app/services/member_service.rb


    class Member::CreateService
      def initialize(params)
        @params = params

      end


      def create_member

        result=check_team_member
        if result[:errors].present?
          return result
        end
        if !@params[:name].present?
          username, domain = @params[:email].split("@")
        else
          username = @params[:name]
        end

        begin
          if !@params[:password].present?
            password = SecureRandom.hex(8)
            bcPassword = BCrypt::Password.create(password)
          else
            bcPassword = BCrypt::Password.create(@params[:password])
          end
          member = ::Member.new(
          name: username,
          phone: @params[:phone],
          address: @params[:address],
          desc: @params[:desc],
          faculty_id: @params[:faculty_id],
          org_name: @params[:org_name],
          profile_url: @params[:profile_url],
          active: @params[:active]
          )
          if member.save

           { message: 'Member created successfully' }
          else
            { errors: @member.errors.full_messages }
          end
          user = User.new(
            email: @params[:email],
            role: @params[:role],
            encrypted_password: bcPassword,
            password_digest: bcPassword,
            member_id: member.id
            )


          if user.save
            puts("call function to sent mail")
            # MailerJob.perform_later(user,member)
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

      # def send_password_email(user,member)
      #   MemberMailer.welcome_email(user,member).deliver_now
      # end
      def check_team_member
        user = ::User.find_by(email: @params[:email])
        if user.present?
          return { errors: ["User with Email #{ @params[:email]} already exist in the System!!"] }
        end
        {}
      end
    end
