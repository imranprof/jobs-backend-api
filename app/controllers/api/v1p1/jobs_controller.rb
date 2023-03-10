# frozen_string_literal: true

module Api
  module V1p1
    class JobsController < ApplicationController
      prepend_before_action :authenticate_request, only: %i[create update destroy apply my_jobs job_seeker_selection hire_job_seeker job_application_show best_matches_jobs most_recent_jobs]
      before_action :authenticate_job_request, only: %i[create update destroy apply my_jobs job_seeker_selection hire_job_seeker]
      before_action :set_job, only: %i[show]

      def index
        @jobs = Job.published
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
          if @job.canceled?
            @job.applicants.each do |applicant|
              JobMailer.job_status_canceled_notification(@job, applicant).deliver_now
            end
          end
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

      def search_by_nof_applicant(jobs, applicants)
        @jobs = []
        jobs.each do |job|
          applicants.each do |range|
            min = range[:min]
            max = range[:max]
            nof_applicant = job.applicants.count
            @jobs.append(job) if nof_applicant >= min && nof_applicant <= max
          end
        end
        @jobs.uniq(&:id)
      end

      def search_by_value
        value = search_params[:search_value].downcase
        Job.by_value(value)
      end

      def search
        rates = nil
        pay_types = nil
        applicants = nil
        rates = search_params[:rate][:range] if search_params[:rate].present?
        pay_types = search_params[:pay_type] if search_params[:pay_type].present?
        applicants = search_params[:applicant][:range] if search_params[:applicant].present?
        @jobs = []
        if rates && !pay_types && !applicants
          rates.each do |range|
            min = range[:min]
            max = range[:max]
            @jobs += search_by_value.by_rate(min, max)
          end

        elsif pay_types && !rates && !applicants
          @jobs += search_by_value.by_pay_type(pay_types)

        elsif applicants && !rates && !pay_types
          search_by_nof_applicant(search_by_value, applicants)

        elsif rates && pay_types && !applicants
          rates.each do |range|
            min = range[:min]
            max = range[:max]
            @jobs += search_by_value.by_pay_type(pay_types).by_rate(min, max)
          end

        elsif rates && applicants && !pay_types
          rates.each do |range|
            min = range[:min]
            max = range[:max]
            @jobs += search_by_value.by_rate(min, max)
          end
          search_by_nof_applicant(@jobs, applicants)
        elsif pay_types && applicants && !rates
          @jobs = search_by_value.by_pay_type(pay_types)
          search_by_nof_applicant(@jobs, applicants)
        elsif pay_types && applicants && rates
          rates.each do |range|
            min = range[:min]
            max = range[:max]
            @jobs += search_by_value.by_pay_type(pay_types).by_rate(min, max)
          end
          search_by_nof_applicant(@jobs, applicants)
        else
          @jobs = search_by_value
        end
        @jobs = @jobs.uniq(&:id)
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

      def best_matches_jobs
        user = current_user
        @best_matches_jobs = Job.find_best_jobs_by_skills(user)
      end

      def most_recent_jobs
        user = current_user
        @most_recent_jobs = Job.find_recent_jobs_by_skills(user, jobs_page_params[:page])
      end

      private

      def job_application_param
        params.require(:job_application).permit(%i[id selection cover_letter bid_rate email hire_rate pay_type])
      end

      def jobs_page_params
        params.permit(:page)
      end

      def job_params
        params.require(:job).permit(%i[id title description location skills pay_type budget status])
      end

      def search_params
        params.require(:job).permit(:search_value, pay_type: [], rate: [range: %i[min max]],
                                                   applicant: [range: %i[min max]])
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
