# frozen_string_literal: true

module Api
  module V1p1
    class JobsController < ApplicationController
      before_action :authenticate_request, only: %i[create update destroy apply]
      before_action :set_job, only: %i[show update destroy]

      EMPLOYER = 'employer'
      EMPLOYEE = 'employee'

      def index
        @jobs = Job.all
      end

      def show; end

      def create
        unless current_user.role == EMPLOYER
          @error = 'Only employer can create job post'
          render :error, status: :unprocessable_entity and return
        end
        @job = current_user.jobs.new(jobs_params)
        unless @job.save
          @error = 'Unable to create job'
          render :error, status: :unprocessable_entity and return
        end
        render :show, status: :ok
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
        job = current_user.jobs.find_by(id: jobs_params[:id].to_i)
        unless job
          @error = 'Failed to delete the job'
          render :error, status: :unprocessable_entity and return
        end
        job.destroy
        head :ok
      end

      def apply
        unless current_user.role == EMPLOYEE
          @error = 'Only employee can apply for job'
          render :error, status: :unprocessable_entity and return
        end
        unless JobApplication.new(user_id: current_user.id, job_id: jobs_params[:id].to_i).save
          @error = 'Failed to apply for the job'
          render :error, status: :unprocessable_entity and return
        end
        head :ok
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
