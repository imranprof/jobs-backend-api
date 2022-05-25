# frozen_string_literal: true
module Profile
  class ProfilesController < ApplicationController

    def user_contacts
      @user_contacts = UserContact.all
      render json: @user_contacts, status: :ok
    end

    def create_contact
      @user_contact = UserContact.new(contact_params)
      if @user_contact.save
        render json: @user_contact, status: :created
      else
        render json: @user_contact.errors, status: :unprocessable_entity
      end
    end

    private

    def contact_params
      params.require(:user_contact).permit(:name, :phone_number, :email, :subject, :message, :user_id, :messenger_id)
    end
  end
end