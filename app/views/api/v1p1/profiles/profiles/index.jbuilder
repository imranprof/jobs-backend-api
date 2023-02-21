# frozen_string_literal: true

json.profiles @profiles do |profile|
  json.profile_slug profile.slug
  json.first_name profile.user.first_name
  json.last_name profile.user.last_name
  json.image request.base_url.concat(url_for(profile.avatar))
  json.designation profile.designation
  json.hourly_rate profile.hourly_rate || 20
  json.rating profile.count_rating
  json.completed_jobs profile.user.job_applications.closed.rated.count || 0
  json.skills profile.user.users_skills.map { |users_skill|
    users_skill.skill.title
  }.compact
end
