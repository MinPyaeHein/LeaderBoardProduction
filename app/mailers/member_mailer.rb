class MemberMailer < ApplicationMailer

    def welcome_email(user,member)
      @user = user
      @member=member
      @url  = 'http://localhost:3000/login'
      puts("arrive to mailer==",@user.email)
      mail(to: @user.email, subject: 'Welcome to My Awesome Site')
    end
end
