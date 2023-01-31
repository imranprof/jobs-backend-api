class MessageMailer < ApplicationMailer
  layout "mailer"

  def message_notification_email(message)
    @message = message
    mail(to: message.recipient.email, subject: "You have a new Message from #{message.sender.email}")
  end
end
