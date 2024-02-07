class MemberMailer < ApplicationMailer
    
    def welcome_email( email,password,username)
       
        @username=username
        @password = password
       
        mail(to: email, subject: 'Welcome to YourApp!')
    end
end
