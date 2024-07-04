# app/services/member_service.rb


class Member::LoginLogoutService
    def initialize(params)
      @params = params

    end

    def login
        user = User.find_by(email:@params[:email])
        if !user.nil?
          bool=user.authenticate(@params[:password])
          puts "bool: #{bool}"
          puts "user: #{user}"
          member = user.member if user
          if user.present? && bool
            token = user.generate_jwt
            puts "token: #{token}"
            return  { token: token, user: user, member: member }
          else
            return  { errors: 'Invalid email or password' }
          end
        else
          return  { errors: "User #{@params[:email]} not found" }
        end

    end

    def gest_login
      users = User.joins(:member).where(members: { name: @params[:name] })
      if users.first.present?
        user = users.first
        bool = user.authenticate(@params[:password])
        puts "bool: #{bool}"
        puts "user: #{user}"
        member = user.member if user
        if bool
          token = user.generate_jwt
          puts "token: #{token}"
          return { token: token, user: user, member: member }
        else
          return { errors: 'Invalid email or password' }
        end
      else
        return { errors: "User with name #{@params[:name]} not found" }
      end
    end



    def logout

         { message: 'Logged out successfully' }
    end





  end
