class MailerJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Rails.logger.info "Mailer Job started"
    sleep 5
    Rails.logger.info "Mailer Job started"
  end
end
