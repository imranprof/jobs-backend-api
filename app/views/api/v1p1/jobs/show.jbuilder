# frozen_string_literal: true

json.ignore_nil! true

json.job do
  json.id @job.id
  json.title @job.title
  json.description @job.description
  json.location @job.location
  json.skills @job.skills
  json.employer_id @job.user_id
  json.total_applied @job.applicants.count
end
