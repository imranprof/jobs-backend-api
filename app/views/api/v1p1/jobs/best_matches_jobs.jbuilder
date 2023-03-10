# frozen_string_literal: true

json.jobs @best_matches_jobs do |job|
  json.id job.id
  json.title job.title
  json.description job.description
  json.location job.location
  json.skills job.skills
  json.pay_type job.pay_type
  json.total_applied job.applicants.count
  json.created_at job.created_at
  json.budget job.budget
end
