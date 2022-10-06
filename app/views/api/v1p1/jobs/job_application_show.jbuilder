# frozen_string_literal: true

json.job_application_details do
  json.id @job_application.id
  json.selection @job_application.selection
  json.cover_letter @job_application.cover_letter
  json.hire @job_application.hire
  json.bid_rate @job_application.bid_rate
  json.pay_type @job_application.pay_type
  json.hire_rate @job_application.hire_rate[0]
  json.related_job do
    json.title @job_application.job.title
    json.description @job_application.job.description
  end
end
