module Api
  module V1p1
    class MessagesController < ApplicationController

      before_action :authenticate_request, only: %i[send_message show_threads private_conversation update_message_status]

      def show_threads
        @current_user = current_user
        @threads = current_user.message_threads
      end

      def private_conversation
        message_id = message_params[:id]
        @message = current_user.sent_messages.find_by(id: message_id)
        @message = current_user.received_messages.find_by(id: message_id) if @message.nil?
        if @message.nil?
          @error = 'No message found'
          render :error, status: :unprocessable_entity and return
        end
        @threads = []
        @threads += @message.children.order('created_at DESC')
        @threads.append(@message) if @message.parent_message_id.nil?
        render :show_threads
      end

      def send_message
        if current_user.id == send_message_params[:recipient_id]
          @error = 'message sender and receiver are same'
          render :error, status: :unprocessable_entity and return
        end
        message = current_user.sent_messages.new(send_message_params)
        unless message.save
          @error = 'Failed to send message'
          render :error, status: :unprocessable_entity and return
        end
        ActionCable.server.broadcast 'privateChat_channel', message
        head :ok
      end

      def update_message_status
        message_id = message_params[:id]
        @parent_message = current_user.sent_messages.find_by(id: message_id)
        @parent_message = current_user.received_messages.find_by(id: message_id) if @parent_message.nil?

        if @parent_message.nil?
          @error = 'Failed to update message read status'
          render :error, status: :unprocessable_entity and return
        else
          if !@parent_message.has_read? && @parent_message.recipient_id == current_user.id
            @parent_message.update_column(:has_read, true)
          end
          @messages = @parent_message.children.where('recipient_id = ? AND has_read = ?', current_user.id, false)
          @messages.each do |message|
            message&.update_column(:has_read, true)
          end
          head :ok
        end
      end

      private

      def send_message_params
        params.require(:message).permit(%i[body recipient_id parent_message_id])
      end

      def message_params
        params.require(:message).permit(%i[id])
      end

    end
  end
end
