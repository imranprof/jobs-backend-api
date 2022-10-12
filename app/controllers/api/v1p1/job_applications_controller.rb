# frozen_string_literal: true

module Api
  module V1p1
    class JobApplicationsController < ApplicationController
      prepend_before_action :authenticate_request, only: %i[job_offers show_job_offer]
      before_action :authenticate_application_request, only: %i[job_offers show_job_offer]

      def job_offers
        @job_offers = current_user.job_applications.where('hire = ?', true)
      end

      def show_job_offer
        @job_offer = current_user.job_applications.find_by(id: params[:id], hire: true)
        return if @job_offer

        @error = 'Job offer not found'
        render :error, status: :not_found
      end

      def authenticate_application_request
        @is_employer = current_user.role == 'employer'
        return if params[:action] == 'job_offers' && !@is_employer
        return if params[:action] == 'show_job_offer' && !@is_employer

        @error = 'You can not perform this action'
        render :error, status: :unauthorized
      end

    end
  end
end
