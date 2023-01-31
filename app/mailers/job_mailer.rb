class JobMailer < ApplicationMailer
  layout "mailer"

  def job_status_canceled_notification(job, applicant)
    @job = job
    @applicant = applicant
    mail(to: @applicant.email, subject: "You have a notification  on #{@job.title} job")
  end

  def contract_end_notification_mail(contract, modifier, recipient)
    @contract = contract
    @modifier = modifier
    @recipient = recipient
    mail(to: @recipient.email, subject: "You have a contract end notification  on #{@contract.job.title} job")
  end

  def contract_feedback_rating_notification_mail(contract, modifier, recipient)
    @contract = contract
    @modifier = modifier
    @recipient = recipient
    mail(to: @recipient.email, subject: "You have a feedback  on #{@contract.job.title} job")
  end

end
