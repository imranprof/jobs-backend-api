class JobMailer < ApplicationMailer
  layout "mailer"

  def job_status_canceled_notification(job, applicant)
    @job = job
    @applicant = applicant
    mail(to: @applicant.email, subject: "You have a notification  on #{@job.title} job")
  end

end
