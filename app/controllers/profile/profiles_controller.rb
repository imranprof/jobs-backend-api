# frozen_string_literal: true
module Profile
  class ProfilesController < ApplicationController

    def create_contact
      @user_contact = UserContact.new(contact_params)
      if @user_contact.save
        render json: { message: 'Message has been sent successfully.' }, status: :created
      else
        render json: { message: 'Sorry, something wrong' }
      end
    end

    private

    def contact_params
      params.require(:user_contact).permit(:name, :phone_number, :email, :subject, :message, :user_id, :messenger_id)
    end
  end
end