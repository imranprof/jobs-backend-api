# frozen_string_literal: true

class AuthenticationController < ApplicationController
  skip_before_action :authenticate_request, only: :sign_in

  def sign_in
    command = AuthenticateUser.call(params[:email], params[:password])
    if command.success?
      response = { userEmail: command.result.email, authToken: command.result.token }
      render json: response
    else
      render json: { message: command.errors[:user_authentication] }, status: :unauthorized
    end
  end

  def sign_out
    command = current_user.update_column(:token, '')
    if command
      render json: { sign_out: command }
    else
      render json: { error: command.errors }, status: :unauthorized
    end
  end
end
