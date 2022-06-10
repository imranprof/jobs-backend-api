# frozen_string_literal: true

class ApplicationController < ActionController::API
  attr_reader :current_user

  private

  def authenticate_request
    @current_user = AuthorizeApiRequest.call(request.headers).result
    render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_user
  end
end
