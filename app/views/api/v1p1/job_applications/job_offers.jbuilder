# frozen_string_literal: true

json.job_offers @job_offers do |offer|
  json.application_id   offer.id
  json.related_job_title  offer.job.title
end
