class TimesheetMailer < ApplicationMailer
  layout "mailer"

  def send_work_timesheet_to_employer(job_application)
    @job_application = job_application
    # @url = "http://localhost:8080/job/contract/#{@job_application.id}"
    mail(to: @job_application.job.employer.email, subject: "You have a new application on #{@job_application.job.title}")
  end
end
