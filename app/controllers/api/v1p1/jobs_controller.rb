# frozen_string_literal: true

module Api
  module V1p1
    class JobsController < ApplicationController
      prepend_before_action :authenticate_request, only: %i[create update destroy apply my_jobs job_seeker_selection]
      before_action :authenticate_job_request, only: %i[create update destroy apply my_jobs job_seeker_selection]
      before_action :set_job, only: %i[show]

      def index
        @jobs = Job.all
      end

      def show; end

      def create
        @job = current_user.jobs.new(job_params)
        unless @job.save
          @error = 'Unable to create job'
          render :error, status: :unprocessable_entity and return
        end
        render :show, status: :created
      end

      def update
        @job = current_user.jobs.find_by(id: job_params[:id].to_i)
        if @job&.update(job_params)
          render :show, status: :ok
        else
          @error = 'Failed to update job'
          render :error, status: :unprocessable_entity
        end
      end

      def destroy
        current_user.jobs.find_by(id: job_params[:id].to_i).destroy
        head :no_content
      end

      def apply
        unless JobApplication.new(user_id: current_user.id, job_id: job_params[:id].to_i, selection: false).save
          @error = 'Failed to apply for the job'
          render :error, status: :unprocessable_entity and return
        end
        head :ok
      end

      def job_seeker_selection
        @job_application = JobApplication.find_by(id: job_application_param[:id])
        @has_job = current_user.jobs.find_by(id: @job_application.job_id)
        if @has_job && @job_application&.update(job_application_param)
          head :ok
        else
          @error = 'Failed to update'
          render :error, status: :unprocessable_entity
        end
      end

      def my_jobs
        @user_id = current_user.id
        @jobs = if @is_employer
                  current_user.jobs.all
                else
                  current_user.applied_jobs
                end
      end

      def authenticate_job_request
        @is_employer = current_user.role == 'employer'
        return if params[:action] == 'my_jobs'
        return if params[:action] == 'apply' && !@is_employer
        return if params[:action] == 'create' && @is_employer
        return if params[:action] == 'job_seeker_selection' && @is_employer

        if params[:action] == 'destroy' || params[:action] == 'update'
          return if current_user.jobs.find_by(id: job_params[:id].to_i) && @is_employer
        end

        @error = 'You can not perform this action'
        render :error, status: :unauthorized
      end

      private

      def job_application_param
        params.require(:job_application).permit(%i[id selection])
      end

      def job_params
        params.require(:job).permit(%i[id title description location skills])
      end

      def set_job
        @job = Job.find_by(id: job_params[:id].to_i)
        unless @job
          @error = 'Job is not found'
          render :error, status: :not_found
        end
      end
    end
  end
end
