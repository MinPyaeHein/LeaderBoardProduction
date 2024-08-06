class MailerJob < ApplicationJob
  queue_as :default

  def perform(*args)
    puts " Mailer Job started"
    sleep 5
    puts "Mailer Job completed"
  end
end
