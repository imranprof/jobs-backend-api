class TimesheetMailer < ApplicationMailer
  layout "mailer"

  def send_work_timesheet_to_employer(job_application)
    @job_application = job_application
    mail(to: @job_application.job.employer.email, subject: "You have a new application on #{@job_application.job.title}")
  end

  def timesheet_response_to_job_seeker(job_application, status)
    @job_application = job_application
    @status = status
    mail(to: @job_application.user.email, subject: "#{@job_application.job.employer.first_name} responded to your requested weekly timesheet on #{@job_application.job.title} job.")
  end
end
