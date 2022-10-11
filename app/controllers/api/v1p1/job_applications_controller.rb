# frozen_string_literal: true

module Api
  module V1p1
    class JobApplicationsController < ApplicationController
      prepend_before_action :authenticate_request, only: %i[show_job_offers]

      def show_job_offers
        @job_offer = current_user.job_applications.where('hire = ?', true)
      end
    end
  end
end
