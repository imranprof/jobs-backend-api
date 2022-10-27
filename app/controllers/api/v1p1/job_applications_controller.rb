# frozen_string_literal: true

module Api
  module V1p1
    class JobApplicationsController < ApplicationController
      before_action :authenticate_request, only: %i[job_offers show_job_offer accept_hire_offer show_job_contracts]

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
          @job_offer&.update_columns(contract_status: :InProgress) if @job_offer.hire_confirmation?
          JobApplicationMailer.hire_response_notification_email(@job_offer).deliver_now
          head :ok
        else
          @error = 'Failed to confirm hire offer or you are not authorized'
          render :error, status: :unprocessable_entity
        end
      end

      def show_job_contracts
        status = job_contract_param[:contract_status]
        @is_employee = current_user.role == 'employee'
        if @is_employee
          @job_contracts = current_user.job_applications.by_contract_status(status)
        else
          @job_contracts = []
          current_user.jobs.each do |job|
            @job_contracts += job.job_applications.by_contract_status(status)
          end
        end
      end

      private

      def job_offer_param
        params.require(:job_offer).permit(%i[id hire_confirmation])
      end

      def job_contract_param
        params.require(:job_contract).permit(%i[id contract_status])
      end

    end
  end
end
