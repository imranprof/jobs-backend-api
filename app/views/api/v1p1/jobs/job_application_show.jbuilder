# frozen_string_literal: true

json.job_application_details do
  json.id @job_application.id
  json.selection @job_application.selection
  json.cover_letter @job_application.cover_letter
  json.hire @job_application.hire
  json.bid_rate @job_application.bid_rate
  json.pay_type @job_application.pay_type
  json.hire_rate @job_application.hire_rate[0]
  json.applicant_details do
    json.name "#{@job_application.user.first_name} #{@job_application.user.last_name}"
    json.profile_slug @job_application.user.user_profile.slug
    json.avatar request.base_url.concat(url_for(@job_application.user.user_profile.avatar))
  end
  json.related_job do
    json.title @job_application.job.title
    json.description @job_application.job.description
  end
end
