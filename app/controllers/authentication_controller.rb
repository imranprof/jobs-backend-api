# frozen_string_literal: true

class AuthenticationController < ApplicationController
  skip_before_action :authenticate_request, only: :sign_in

  def sign_in
    command = AuthenticateUser.call(params[:email], params[:password])
    if command.success?
      render json: { user_email: command.result.email, auth_token: command.result.token }
    else
      render json: { error: command.errors }, status: :unauthorized
    end
  end

  def sign_out
    command = current_user.update_column(token, '')
    if command
      render json: { sign_out: command }
    else
      render json: { error: command.errors }, status: :unauthorized
    end
  end
end
