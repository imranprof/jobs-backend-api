# frozen_string_literal: true

module Api
  module V1p1
    class DashboardController < ApplicationController
      before_action :authenticate_request, only: %i[index]
      def index
        render json: { message: "Welcome #{current_user.email}" }
      end
    end
  end
end
