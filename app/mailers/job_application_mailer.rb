class JobApplicationMailer < ApplicationMailer
  layout "mailer"

  def employer_notification_email(job_application)
    @job_application = job_application
    mail(to: @job_application.job.employer.email, subject: "You have a new application on #{@job_application.job.title}")
  end

  def job_seeker_notification_email(job_application)
    @job_application = job_application
    mail(to: @job_application.user.email, subject: "You have a new application on #{@job_application.job.title} job")
  end
end