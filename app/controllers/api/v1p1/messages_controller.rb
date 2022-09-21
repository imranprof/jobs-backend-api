module Api
  module V1p1
    class MessagesController < ApplicationController

      before_action :authenticate_request, only: %i[send_message show_threads private_conversation update]

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
        unless current_user.sent_messages.new(send_message_params).save
          @error = 'Failed to send message'
          render :error, status: :unprocessable_entity and return
        end
        head :ok
      end

      def update
        message_id = message_params[:id]
        @message = current_user.received_messages.find_by(id: message_id)
        if @message&.update(message_params)
          head :ok
        else
          @error = 'Failed to update message read status'
          render :error, status: :unprocessable_entity
        end
      end

      private

      def send_message_params
        params.require(:message).permit(%i[body recipient_id parent_message_id])
      end

      def message_params
        params.require(:message).permit(%i[id has_read])
      end

    end
  end
end
