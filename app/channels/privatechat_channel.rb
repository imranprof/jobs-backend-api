class PrivatechatChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'privateChat_channel'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
