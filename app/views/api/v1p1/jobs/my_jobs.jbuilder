# frozen_string_literal: true

json.jobs @jobs.all do |job|
  json.id job.id
  json.title job.title
  json.description job.description
  json.location job.location
  json.skills job.skills
  json.employer_id job.user_id
  json.total_applied job.applicants.count
  if @is_employer
    json.applicants job.applicants do |applicant|
      json.profile_slug applicant.user_profile.slug
    end
  end
end
