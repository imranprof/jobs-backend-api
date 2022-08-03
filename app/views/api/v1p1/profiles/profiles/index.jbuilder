# frozen_string_literal: true

json.profiles @profiles do |profile|
  json.profile_slug profile.slug
  json.first_name profile.user.first_name
  json.last_name profile.user.last_name
  json.image request.base_url.concat(url_for(profile.avatar))
  json.designation profile.designation
  json.hourly_rate profile.hourly_rate || 20
  json.rating nil
  json.completed_jobs 0
  json.skills profile.user.users_skills do |skill|
    json.id skill.id
    json.title skill.skill.title
    json.rating skill.rating
  end
end
