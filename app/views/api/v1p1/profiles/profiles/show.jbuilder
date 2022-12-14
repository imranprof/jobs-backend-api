# frozen_string_literal: true

json.ignore_nil! true

json.profile_slug @user.user_profile.slug

json.edit_permission @edit_permission

json.role @user.role

json.company_name @user.company_name
json.modify_permission @user.modify_role

json.profile do
  json.id @user.user_profile.id
  json.first_name @user.first_name
  json.last_name @user.last_name
  json.headline @user.user_profile.headline
  json.title @user.user_profile.title
  json.bio @user.user_profile.bio
  json.avatar request.base_url.concat(url_for(@user.user_profile.avatar))
  json.expertises @user.user_profile.expertises
  json.social_links do
    json.id @user.user_profile.social_link&.id
    json.facebook @user.user_profile.social_link&.facebook
    json.github @user.user_profile.social_link&.github
    json.linkedin @user.user_profile.social_link&.linkedin
  end
  json.skills @user.users_skills do |users_skill|
    json.id users_skill.id
    json.title users_skill.skill.title
    json.icon request.base_url.concat(url_for(users_skill.skill.icon))
    json.rating users_skill.rating
  end
end

json.portfolio_data do
  json.projects @user.projects.all do |project|
    json.id project.id
    json.title project.title
    json.description project.description
    json.image request.base_url.concat(url_for(project.image))
    json.live_url project.live_url
    json.source_url project.source_url
    json.categories project.categorizations.all do |project_category|
      json.id project_category.id
      json.category_id project_category.category_id
      json.title project_category.category.title
    end
    json.react_count project.react_count
  end
end

json.features @user.features.all do |feature|
  json.id feature.id
  json.title feature.title
  json.description feature.description
  json.icon request.base_url.concat(url_for(feature.icon)) if feature.icon.attached?
end

json.blogs @user.blogs.all do |blog|
  json.id blog.id
  json.title blog.title
  json.body blog.body
  json.image request.base_url.concat(url_for(blog.image))
  json.reading_time blog.reading_time
  json.categories blog.categorizations.all do |blog_category|
    json.id blog_category.id
    json.category_id blog_category.category_id
    json.title blog_category.category.title
  end
end

json.resume_data do
  json.educations @user.education_histories.all do |education|
    json.id education.id
    json.institution education.institution
    json.degree education.degree
    json.grade education.grade
    json.currently_enrolled education.currently_enrolled
    json.visibility education.visibility
    json.start_date education.start_date
    json.end_date education.end_date
    json.description education.description
  end
  json.skills @user.users_skills do |users_skill|
    json.id users_skill.id
    json.skill_id users_skill.skill.id
    json.name users_skill.skill.title
    json.rating users_skill.rating
  end
  json.experiences @user.work_histories do |work|
    json.id work.id
    json.title work.title
    json.employment_type work.employment_type
    json.company_name work.company_name
    json.description work.description
    json.start_date work.start_date
    json.end_date work.end_date
    json.currently_employed work.currently_employed
    json.visibility work.visibility
  end
end

json.contacts_data do
  json.first_name @user.first_name
  json.last_name @user.last_name
  json.contact_email @user.user_profile.contact_email
  json.designation @user.user_profile.designation
  json.description @user.user_profile.contact_info
  json.phone @user.phone || '+88-01112223334'
end

json.all_categories Category.all do |category|
  json.id category.id
  json.title category.title
end

json.all_skills Skill.all do |skill|
  unless skill.custom_skill
    json.id skill.id
    json.title skill.title
    json.icon request.base_url.concat(url_for(skill.icon)) if skill.icon.attached?
  end
end
