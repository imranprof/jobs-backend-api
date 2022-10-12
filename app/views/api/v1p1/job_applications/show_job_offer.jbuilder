# frozen_string_literal: true

json.offer_details do
  json.id @job_offer.id
  json.title @job_offer.job.title
  json.hire_rate @job_offer.hire_rate[0]
  json.hire_confirmation @job_offer.hire_confirmation
end
