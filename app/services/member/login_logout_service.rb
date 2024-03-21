# app/services/member_service.rb


class Member::LoginLogoutService
    def initialize(params)
      @params = params
   
    end

    def login
      user = User.find_by(email: @params[:email].downcase) || User.find_by(email: @params[:email].upcase)
      
      if user.present?
        provided_password = @params[:password].downcase # Convert provided password to lowercase
        stored_password = user.password.downcase # Assuming user's password is stored in lowercase
        
        if provided_password == stored_password
          token = user.generate_jwt
          member = user.member
          return { token: token, user: user, member: member }
        else
          return { errors: 'Invalid email or password' }
        end
      else
        return { errors: "User #{@params[:email]} not found" }
      end
    end
    

    def logout
       
         { message: 'Logged out successfully' }
    end


    

   
  end

