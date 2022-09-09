# frozen_string_literal: true

json.all_threads @threads do |thread|
  json.id thread.id
  json.body thread.body
  json.sender_id thread.sender_id
  json.recipient_id thread.recipient_id
  json.sender_name  "#{thread.sender.first_name} #{thread.sender.last_name}"
  json.recipient_name "#{thread.recipient.first_name} #{thread.recipient.last_name}"
end
