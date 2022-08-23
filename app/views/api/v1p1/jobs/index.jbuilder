# frozen_string_literal: true

json.jobs @jobs do |job|
  json.id job.id
  json.employer_id job.user_id
  json.title job.title
  json.description job.description
  json.location job.location
  json.skills job.skills
end
