class MailerJob < ApplicationJob
  queue_as :default

  def perform(user,member)
    # MemberMailer.welcome_email(user,member).deliver_now
  end
end
