# frozen_string_literal: true

module Api
  module V1p1
    class JobsController < ApplicationController
      prepend_before_action :authenticate_request, only: %i[create update destroy]
      before_action :authenticate_job_request, only: %i[create update destroy]
      before_action :set_job, only: %i[show]

      def index
        @jobs = Job.all
      end

      def show; end

      def create
        @job = current_user.jobs.new(jobs_params)
        unless @job.save
          @error = 'Unable to create job'
          render :error, status: :unprocessable_entity and return
        end
        render :show, status: :created
      end

      def update
        @job = current_user.jobs.find_by(id: jobs_params[:id].to_i)
        if @job&.update(jobs_params)
          render :show, status: :ok
        else
          @error = 'Failed to update job'
          render :error, status: :unprocessable_entity
        end
      end

      def destroy
        current_user.jobs.find_by(id: jobs_params[:id].to_i).destroy
        head :no_content
      end

      def authenticate_job_request
        @is_employer = current_user.role == 'employer'
        return if params[:action] == 'create' && @is_employer
        return if current_user.jobs.find_by(id: jobs_params[:id].to_i) && @is_employer

        @error = 'You can not perform this action'
        render :error, status: :unauthorized
      end

      private

      def jobs_params
        params.require(:job).permit(%i[id title description location skills])
      end

      def set_job
        @job = Job.find_by(id: jobs_params[:id].to_i)
        unless @job
          @error = 'Job is not found'
          render :error, status: :not_found
        end
      end
    end
  end
end
