# frozen_string_literal: true

module Api
  module V1
    class DashboardController < ApplicationController
      def index
        render json: { message: "Welcome #{current_user.email}" }
      end
    end
  end
end
