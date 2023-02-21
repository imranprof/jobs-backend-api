# frozen_string_literal: true

module Api
  module V1p1
    class JobApplicationsController < ApplicationController
      before_action :authenticate_request,
                    only: %i[job_offers show_job_offer accept_hire_offer show_job_contracts show_contract
                             job_contract_end give_feedback_and_rating]

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
          @job_offer&.update_columns(contract_status: :in_progress) if @job_offer.hire_confirmation?
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

      def show_contract
        @is_employee = current_user.role == 'employee'
        @contract = JobApplication.find_by(id: params[:id])
        @job_contract = if @is_employee
                          current_user.job_applications.find_by(id: params[:id])
                        else
                          current_user.jobs.find_by(id: @contract.job_id)&.job_applications&.find_by(id: @contract.id)
                        end
        return if @job_contract

        @error = 'Job contract not found'
        render :error, status: :not_found
      end

      def job_contract_end
        value = JobApplication.find_job_contract(job_contract_param[:id], current_user)
        unless value.nil?
          @job_contract = value[0]
          @recipient = value[1]
        end
        if @job_contract&.update(job_contract_param)
          if @job_contract.contract_status == 'closed'
            JobMailer.contract_end_notification_mail(@job_contract, current_user, @recipient).deliver_now
          end
          head :ok
        else
          @error = 'Failed to change contract status or you are not authorized'
          render :error, status: :unprocessable_entity
        end
      end

      def give_feedback_and_rating
        value = JobApplication.find_job_contract(feedback_param[:id], current_user)
        unless value.nil?
          @job_contract = value[0]
          @recipient = value[1]
        end
        feedback = feedback_param[:feedback]
        rating = feedback_param[:rating]
        @is_employee = current_user.role == 'employee'

        if @is_employee
          if @job_contract&.update_columns(employee_feedback: feedback, employee_rating: rating)
            JobMailer.contract_feedback_rating_notification_mail(@job_contract, current_user, @recipient).deliver_now
            head :ok
          else
            @error = 'Failed to give rating or you are not authorized'
            render :error, status: :unprocessable_entity
          end
        else

          if @job_contract&.update_columns(employer_feedback: feedback, employer_rating: rating)
            JobMailer.contract_feedback_rating_notification_mail(@job_contract, current_user, @recipient).deliver_now
            head :ok
          else
            @error = 'Failed to give rating or you are not authorized'
            render :error, status: :unprocessable_entity
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

      def feedback_param
        params.require(:job_contract).permit(%i[id feedback rating])
      end

    end
  end
end
