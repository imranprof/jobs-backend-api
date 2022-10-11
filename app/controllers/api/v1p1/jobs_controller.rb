# frozen_string_literal: true

module Api
  module V1p1
    class JobsController < ApplicationController
      prepend_before_action :authenticate_request, only: %i[create update destroy apply my_jobs job_seeker_selection hire_job_seeker job_application_show]
      before_action :authenticate_job_request, only: %i[create update destroy apply my_jobs job_seeker_selection hire_job_seeker]
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
        unless JobApplication.new(user_id: current_user.id, job_id: job_params[:id].to_i, selection: false, cover_letter: job_application_param[:cover_letter], bid_rate: job_application_param[:bid_rate]).save
          @error = 'Failed to apply for the job'
          render :error, status: :unprocessable_entity and return
        end
        head :ok
      end

      def job_application_show
        @application = JobApplication.find_by(id: params[:id])
        unless @application
          @error = 'Job Application not found'
          render :error, status: :not_found and return
        end
        @job_application = current_user.jobs.find_by(id: @application.job_id)&.job_applications&.find_by(id: @application.id)
        @job_application = current_user.job_applications.find_by(id: @application.id) if @job_application.nil?
        unless @job_application
          @error = 'You are not authorized for this job application'
          render :error, status: :unprocessable_entity
        end
      end

      def hire_job_seeker
        application_id = job_application_param[:id]
        @application = JobApplication.find_by(id: application_id)
        unless @application
          @error = 'Job Application not found'
          render :error, status: :not_found and return
        end
        @job_application = current_user.jobs.find_by(id: @application&.job_id)&.job_applications&.find_by(id: application_id)
        hire_rate = job_application_param[:hire_rate]
        pay_type = job_application_param[:pay_type]
        if @job_application&.update_columns(hire: true, hire_rate: hire_rate, pay_type: pay_type)
          head :ok
          JobApplicationMailer.job_seeker_hire_notification_email(@job_application).deliver_now
        else
          @error = 'Failed to hire or you are not authorized'
          render :error, status: :unprocessable_entity
        end
      end

      def job_seeker_selection
        @email = job_application_param[:email]
        @job_application = JobApplication.find_by(id: job_application_param[:id])

        if @email
          JobApplicationMailer.job_seeker_notification_email(@job_application).deliver_now
          head :ok and return
        end

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

      def search
        value = search_params[:search_value].downcase

        @jobs = Job.where("lower(array_to_string(skills, '||')) LIKE ?
                           OR lower(title) LIKE ?
                           OR lower(description) LIKE ?", "%#{value}%", "%#{value}%", "%#{value}%")
        render :index
      end

      def authenticate_job_request
        @is_employer = current_user.role == 'employer'
        return if params[:action] == 'my_jobs'
        return if params[:action] == 'apply' && !@is_employer
        return if params[:action] == 'create' && @is_employer
        return if params[:action] == 'job_seeker_selection' && @is_employer
        return if params[:action] == 'hire_job_seeker' && @is_employer

        if params[:action] == 'destroy' || params[:action] == 'update'
          return if current_user.jobs.find_by(id: job_params[:id].to_i) && @is_employer
        end

        @error = 'You can not perform this action'
        render :error, status: :unauthorized
      end

      private

      def job_application_param
        params.require(:job_application).permit(%i[id selection cover_letter bid_rate email hire_rate pay_type])
      end

      def job_params
        params.require(:job).permit(%i[id title description location skills pay_type budget])
      end

      def search_params
        params.permit(:search_value)
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
