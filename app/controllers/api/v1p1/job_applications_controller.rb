# frozen_string_literal: true

module Api
  module V1p1
    class JobApplicationsController < ApplicationController
      before_action :authenticate_request, only: %i[job_offers show_job_offer accept_hire_offer best_matches_jobs]

      def job_offers
        @job_offers = current_user.job_applications.where('hire = ?', true)
      end

      def show_job_offer
        @job_offer = current_user.job_applications.find_by(id: params[:id], hire: true)
        return if @job_offer

        @error = 'Job offer not found'
        render :error, status: :not_found
      end

      def best_matches_jobs
        @jobs = []
        current_user.skills.each do |skill|
          @jobs += Job.where("lower(array_to_string(skills, '||')) LIKE ? ", "%#{skill.title.downcase}%")
        end
        @jobs = @jobs.uniq.take(10)
      end

      def accept_hire_offer
        offer_id = job_offer_param[:id]
        @job_offer = current_user.job_applications.find_by(id: offer_id, hire: true)
        unless @job_offer
          @error = 'Job offer not found'
          render :error, status: :not_found and return
        end
        if @job_offer&.update(job_offer_param)
          JobApplicationMailer.hire_response_notification_email(@job_offer).deliver_now
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
