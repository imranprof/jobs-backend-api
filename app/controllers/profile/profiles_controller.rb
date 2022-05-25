# frozen_string_literal: true
module Profile
  class ProfilesController < ApplicationController

    def current_user_contacts
      @user_contacts = UserContact.where(user_id: params[:user_id])
      #@user_contacts = UserContact.all
      render json: @user_contacts, status: :ok
    end

    def create_contact
      @user_contact = UserContact.new(contact_params)
      if @user_contact.save
        render json: { message: 'Message has been sent successfully.' }, status: :ok
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