# frozen_string_literal: true

module Api
  module V1p1
    class JobContractsController < ApplicationController

      before_action :authenticate_request, only: %i[add_working_details]

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

      private

      def working_details_param
        params.require(:job_contract).permit(%i[id start_date end_date work_description work_hours job_application_id])

      end


    end
  end
end
