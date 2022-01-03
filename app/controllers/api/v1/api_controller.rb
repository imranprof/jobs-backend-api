# frozen_string_literal: true

module Api
  module V1
    class ApiController < ApplicationController
      def seek_right_jobs
        render json: { message: "Welcome #{current_user.email}" }
      end
    end
  end
end
