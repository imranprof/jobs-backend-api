# frozen_string_literal: true

module Api
  module V1p1
    class JobContractsController < ApplicationController

      before_action :authenticate_request, only: %i[add_working_details show_time_sheets update_working_details destroy_time_sheet]

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

        if @time_sheet&.update_columns(start_date: start_date, end_date: end_date, work_description: work_description, work_hours: work_hours)
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

        @time_sheets = @contract.time_sheets
      end

      private

      def working_details_param
        params.require(:job_contract).permit(%i[id start_date end_date work_description work_hours job_application_id])

      end


    end
  end
end
