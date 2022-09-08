module Api
  module V1p1
    class MessagesController < ApplicationController

      before_action :authenticate_request, only: %i[send_message show_threads]

      def show_threads
        @threads = current_user.message_threads
      end

      def send_message
        raise current_user.inspect
        if current_user.id == message_params[:recipient_id]
          @error = 'message sender and receiver are same'
          render :error, status: :unprocessable_entity and return
        end
        unless current_user.sent_messages.new(body: message_params[:body], recipient_id: message_params[:recipient_id]).save
          @error = 'Failed to send message'
          render :error, status: :unprocessable_entity and return
        end
        head :ok
      end

      private

      def message_params
        params.require(:message).permit(%i[body recipient_id])
      end

    end
  end
end