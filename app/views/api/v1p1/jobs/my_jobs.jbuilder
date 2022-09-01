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
      json.email applicant.email
      json.avatar request.base_url.concat(url_for(applicant.user_profile.avatar))
      applicant.job_applications.each do |application|
        @application_id = application.id if application.job_id == job.id
      end
      json.application_id @application_id
    end
  else
    job.job_applications.each do |application|
      @short_list = false
      @short_list = application.selection if application.user.id == @user_id
    end
    json.short_list @short_list
  end

end
