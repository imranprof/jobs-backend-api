# frozen_string_literal: true

module Api
  module V1p1
    class JobsController < ApplicationController
      before_action :authenticate_request, only: %i[create update destroy]
      before_action :set_job, only: %i[show update destroy]

      EMPLOYER = 'employer'

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
        if @job.update(jobs_params)
          render :show, status: :ok
        else
          @error = 'Failed to update job'
          render :error, status: :unprocessable_entity
        end
      end

      def destroy
        @job.destroy
      end

      private

      def jobs_params
        params.permit(%i[id title description location skills])
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
