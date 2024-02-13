# app/services/member_service.rb


class Member::LoginLogoutService
    def initialize(params)
      @params = params
   
    end

    def login
        user = User.find_by(email:@params[:email])
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
      
    end

    def logout
       
         { message: 'Logged out successfully' }
    end


    

   
  end

