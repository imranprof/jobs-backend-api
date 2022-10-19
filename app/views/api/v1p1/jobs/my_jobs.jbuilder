# frozen_string_literal: true

json.jobs @jobs.all do |job|
  json.id job.id
  json.title job.title
  json.description job.description
  json.location job.location
  json.skills job.skills
  json.pay_type job.pay_type
  json.employer_id job.user_id
  json.total_applied job.applicants.count
  json.created_at job.created_at
  json.budget job.budget
  if @is_employer
    json.status_label job.status
    json.status_value Job.statuses[job.status]
    json.applicants job.applicants do |applicant|
      json.applicant_id applicant.id
      json.profile_slug applicant.user_profile.slug
      json.email applicant.email
      json.avatar request.base_url.concat(url_for(applicant.user_profile.avatar))
      applicant.job_applications.each do |application|
        if application.job_id == job.id
          @application_id = application.id
          @short_list = application.selection
          @cover_letter = application.cover_letter
          @bid_rate = application.bid_rate
          @hire_confirmation = application.hire_confirmation
        end
      end
      json.application_id @application_id
      json.short_list @short_list
      json.hire_confirmation @hire_confirmation
      json.cover_letter @cover_letter
      json.bid_rate @bid_rate
    end
  else
    job.job_applications.each do |application|
      @short_list = application.selection if application.user.id == @user_id
      @bid_rate = application.bid_rate if application.user.id == @user_id
    end
    json.short_list @short_list
    json.bid_rate @bid_rate
  end

end
