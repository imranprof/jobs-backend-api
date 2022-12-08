# frozen_string_literal: true

module Api
  module V1p1
    class JobContractsController < ApplicationController

      before_action :authenticate_request, only: %i[add_working_details show_time_sheets update_working_details destroy_time_sheet send_timesheet_to_employer approved_rejected_weekly_timesheet]

      def add_working_details
        contract_id = working_details_param[:job_application_id]
        @contract = current_user.job_applications&.find_by(id: contract_id)
        @time_sheet = @contract&.time_sheets&.new(working_details_param)
        unless @time_sheet&.save
          @error = 'Unable to create time sheet for job contract'
          render :error, status: :unprocessable_entity and return
        end
        head :created
      end

      def update_working_details
        @time_sheet = TimeSheet.find_by(id: working_details_param[:id])
        @contract = @time_sheet&.contract
        @user_contract = current_user.job_applications&.find_by(id: @contract&.id)

        unless @user_contract
          @error = 'You are not authorize to update time sheet or not found'
          render :error, status: :unprocessable_entity and return
        end

        start_date = working_details_param[:start_date]
        end_date = working_details_param[:end_date]
        work_description = working_details_param[:work_description]
        work_hours = working_details_param[:work_hours]
        work_minutes = working_details_param[:work_minutes]

        if @time_sheet&.update_columns(start_date: start_date, end_date: end_date, work_description: work_description, work_hours: work_hours, work_minutes: work_minutes)
          render :show_time_sheet, status: :ok
        else
          @error = 'Failed to update time sheet'
          render :error, status: :unprocessable_entity
        end
      end

      def destroy_time_sheet
        @time_sheet = TimeSheet.find_by(id: working_details_param[:id])
        @contract = @time_sheet&.contract
        @user_contract = current_user.job_applications&.find_by(id: @contract&.id)

        unless @user_contract
          @error = 'You are not authorize to delete this or not found'
          render :error, status: :unprocessable_entity and return
        end

        unless @time_sheet
          @error = 'Failed to delete time sheet'
          render :error, status: :unprocessable_entity and return
        end

        @time_sheet.destroy
        head :no_content
      end

      def show_time_sheet; end

      def show_time_sheets
        contract_id = params[:contract_id]
        @application = JobApplication.find_by(id: contract_id)
        @contract = current_user.jobs.find_by(id: @application&.job_id)&.job_applications&.find_by(id: contract_id)
        @contract = current_user.job_applications&.find_by(id: contract_id) if @contract.nil?

        unless @contract
          @error = 'You are not authorize or time sheet not found'
          render :error, status: :unprocessable_entity and return
        end

        @time_sheets = @contract.time_sheets.where('status != ?', 2)
        @time_sheets = @contract.time_sheets.requested if current_user.role == 'employer'
      end

      def send_timesheet_to_employer
        @job_application = JobApplication.find_by(id: job_contract_param[:id])
        timesheet_ids = timesheet_param[:timesheet_ids]
        @is_employee = current_user.role == 'employee'

        @time_sheets = []
        if @is_employee
          timesheet_ids.each do |id|
            time_sheet = TimeSheet.find_by(id: id)
            head :accepted if time_sheet&.update_columns(status: :requested)
          end
          TimesheetMailer.send_work_timesheet_to_employer(@job_application).deliver_now
        end
      end

      def approved_rejected_weekly_timesheet
        @job_application = JobApplication.find_by(id: job_contract_param[:id])
        @requested_timesheet_ids = @job_application.time_sheets.requested.ids
        @is_employer = current_user.role == 'employer'
        status = job_contract_param[:status]

        if @is_employer
          @requested_timesheet_ids.each do |id|
            time_sheet = TimeSheet.find_by(id: id)
            if status == 'approved'
              head :accepted if time_sheet&.update_columns(status: :approved)
            else
              head :accepted if time_sheet&.update_columns(status: :rejected)
            end
          end
          TimesheetMailer.timesheet_response_to_job_seeker(@job_application, status).deliver_now
        end
      end

      private

      def job_contract_param
        params.require(:job_contract).permit(%i[id status])
      end

      def timesheet_param
        params.require(:job_contract).permit(timesheet_ids: [])
      end

      def working_details_param
        params.require(:job_contract).permit(%i[id start_date end_date work_description work_hours work_minutes job_application_id])
      end

    end
  end
end
