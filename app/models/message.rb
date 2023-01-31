class Message < ApplicationRecord
  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id'
  belongs_to :recipient, class_name: 'User', foreign_key: 'recipient_id'

  belongs_to :parent, class_name: 'Message', foreign_key: 'parent_message_id', optional: true
  has_many :children, class_name: 'Message', foreign_key: 'parent_message_id'

  def parent_threads
    Message.where('parent_message_id is null')
  end

  validates :body, presence: true

end
