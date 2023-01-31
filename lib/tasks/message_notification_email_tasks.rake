namespace :notification do
  desc 'send message notification email'

  task send_message_notification_email: :environment do
    @messages = Message.last.parent_threads
    @messages.each do |message|
      msg = Message.find_by(id: message.id).children.last
      unless msg.has_read
        MessageMailer.message_notification_email(msg).deliver_now
      end
    end
  end

end
