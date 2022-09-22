# frozen_string_literal: true

@total_notification_count = 0
json.all_threads @threads do |thread|
  json.id thread.id
  json.body thread.body
  json.sender_id thread.sender_id
  json.recipient_id thread.recipient_id
  json.sender_name "#{thread.sender.first_name} #{thread.sender.last_name}"
  json.recipient_name "#{thread.recipient.first_name} #{thread.recipient.last_name}"
  json.logged_in_user_id @current_user.id
  json.sender_avatar request.base_url.concat(url_for(thread.sender.user_profile.avatar))
  json.recipient_avatar request.base_url.concat(url_for(thread.recipient.user_profile.avatar))
  if thread.parent_message_id.nil?
    @parent_message_unread = false
    @parent_message_unread = true if thread.has_read == false && thread.recipient_id == @current_user.id
    @unread_count = thread.children.where('has_read = ? AND recipient_id = ?', false, @current_user.id).count
    @unread_count += 1 if @parent_message_unread
    json.unread_count @unread_count
    @total_notification_count += 1 if @unread_count.positive?
    @last_message = thread.children.last
    @last_message = thread if @last_message.nil?
    json.last_message_body @last_message.body
  end
  json.date_time thread.created_at
end

json.total_notification_count @total_notification_count
