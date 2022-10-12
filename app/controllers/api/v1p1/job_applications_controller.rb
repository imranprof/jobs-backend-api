# frozen_string_literal: true

module Api
  module V1p1
    class JobApplicationsController < ApplicationController
      before_action :authenticate_request, only: %i[job_offers show_job_offer accept_hire_offer]

      def job_offers
        @job_offers = current_user.job_applications.where('hire = ?', true)
      end

      def show_job_offer
        @job_offer = current_user.job_applications.find_by(id: params[:id], hire: true)
        return if @job_offer

        @error = 'Job offer not found'
        render :error, status: :not_found
      end

      def accept_hire_offer
        offer_id = job_offer_param[:id]
        @job_offer = current_user.job_applications.find_by(id: offer_id, hire: true)
        unless @job_offer
          @error = 'Job offer not found'
          render :error, status: :not_found and return
        end
        if @job_offer&.update(job_offer_param)
          head :ok
        else
          @error = 'Failed to confirm hire offer or you are not authorized'
          render :error, status: :unprocessable_entity
        end
      end

      private

      def job_offer_param
        params.require(:job_offer).permit(%i[id hire_confirmation])
      end

    end
  end
end
