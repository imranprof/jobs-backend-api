# frozen_string_literal: true

class SocialAuthController < ApplicationController

  def linkedin_auth
    user = User.find_or_create_by(email: auth_user_params[:email]) do |u|
      u.first_name = auth_user_params[:first_name]
      u.last_name = auth_user_params[:last_name]
      u.modify_role = true
      u.password = SecureRandom.hex(12)
    end

    if user.valid?
      api_key = Rails.application.credentials.seekrightjobs[:api_key]
      auth_token = JsonWebToken.encode({ user_id: user.id, api_key: api_key })
      user.update_column(:token, auth_token)
      sign_in_with_linkedin(user)
    else
      render json: { message: 'invalid credentials' }, status: :unauthorized
    end
  end

  def sign_in_with_linkedin(user)
    if user
      response = { profile_slug: user.user_profile.slug, userEmail: user.email, authToken: user.token, role: user.role }
      render json: response
    else
      render json: { message: 'user not found' }, status: :unauthorized
    end
  end

  private

  def auth_user_params
    params.require(:social_auth).permit(:first_name, :last_name, :email, :role, :company_name)
  end

end
