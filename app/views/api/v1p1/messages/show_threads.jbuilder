# frozen_string_literal: true

json.all_threads @threads do |thread|
  json.id thread.id
  json.body thread.body
  json.sender_id thread.sender_id
  json.recipient_id thread.recipient_id
end
