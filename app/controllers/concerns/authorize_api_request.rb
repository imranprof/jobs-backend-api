# frozen_string_literal: true

require 'json_web_token'

class AuthorizeApiRequest
  prepend SimpleCommand

  def initialize(headers = {})
    @headers = headers
  end

  def call
    user
  end

  private

  attr_reader :headers

  def user
    @user ||= User.find_by(token: http_auth_header) if signature_checked && decoded_auth_token
  rescue StandardError => e
    # Ignored
  end

  def signature_checked
    decoded_auth_token[:api_key] == Rails.application.credentials.seekrightjobs[:api_key]
  end

  def decoded_auth_token
    @decoded_auth_token ||= JsonWebToken.decode(http_auth_header)
  end

  def http_auth_header

    return headers['Authorization'].split(' ').last if headers['Authorization'].present?

    errors.add(:token, 'Missing token')
    nil
  end
end
