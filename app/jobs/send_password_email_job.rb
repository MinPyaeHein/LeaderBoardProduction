# class SendPasswordEmailJob < ApplicationJob
#   queue_as :default
#   def perform(email, password, username)
#     MemberMailer.welcome_email(email, password, username)
#   end
# end
