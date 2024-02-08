# app/services/member_service.rb


class Member::LoginLogoutService
    def initialize(params)
      @params = params
   
    end

    def login
        user = User.find_by(email:@params[:email])
        bool=user.authenticate(@params[:password])
        member = user.member if user
        if user && bool
          token = user.generate_jwt
          { token: token, user: user, member: member }
        else
          { error: 'Invalid email or password' }
        end
    end

    def logout
       
         { message: 'Logged out successfully' }
    end


    

   
  end

