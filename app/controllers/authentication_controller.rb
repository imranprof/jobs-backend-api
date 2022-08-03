# frozen_string_literal: true

class AuthenticationController < ApplicationController
  before_action :authenticate_request, only: %i[sign_out]

  def sign_in
    auth_response = AuthenticateUser.call(params[:email], params[:password])
    if auth_response.success?
      response = { profile_slug: auth_response.result.user_profile.slug, userEmail: auth_response.result.email, authToken: auth_response.result.token }
      render json: response
    else
      render json: { message: auth_response.errors[:user_authentication] }, status: :unauthorized
    end
  end

  def sign_out
    if current_user.update_column(:token, '')
      render json: { sign_out: true }
    else
      render json: { error: 'Could not sign out'.errors }, status: :unauthorized
    end
  end
end
