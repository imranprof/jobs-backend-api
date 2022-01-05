# frozen_string_literal: true

require 'json_web_token'

class AuthenticateUser
  prepend SimpleCommand
  attr_accessor :email, :password

  def initialize(email, password)
    @email = email
    @password = password
  end

  def call
    user = User.find_by(email: email)
    if user&.authenticate(password)
      api_key = Rails.application.credentials.seekrightjobs[:api_key]
      auth_token = JsonWebToken.encode({ user_id: user.id, api_key: api_key })
      user.update_column(:token, auth_token)
      user
    else
      errors.add :user_authentication, 'invalid credentials'
      nil
    end
  end

end
