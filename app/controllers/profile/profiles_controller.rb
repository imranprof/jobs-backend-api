module Profile
  class ProfilesController < ApplicationController

    def show
      if current_user.user_profile
        data = {
          profile_data: profile_data,
          features_data: features_data,
          portfolio_data: portfolio_data,
          resume_data: resume_data,
          blogs_data: blogs_data,
          contacts_data: contacts_data
        }
        render json: data, status: :ok
      else
        render json: { message: 'User does not have a profile' }, status: :ok
      end
    end

    private

    def profile_data
      profile = current_user.user_profile
      {
        first_name: profile.user.first_name,
        last_name: profile.user.last_name,
        headline: profile.headline,
        title: profile.title,
        bio: profile.bio,
        avatar: url_for(profile.avatar),
        expertises: profile.expertises,
        social_links: [
          { id: 1, name: 'facebook', url: profile.social_link&.facebook_url },
          { id: 2, name: 'github', url: profile.social_link&.github_url },
          { id: 3, name: 'linkedin', url: profile.social_link&.linkedin_url }
        ],
        skills: profile.user.users_skills.map do |users_skill|
          { id: users_skill.id, name: users_skill.skill.title, rating: users_skill.rating }
        end.compact
      }
    end

    def portfolio_data
      current_user.projects.all.map do |project|
        {
          id: project.id,
          title: project.title,
          description: project.description,
          image: url_for(project.image),
          live_url: project.live_url,
          source_url: project.source_url,
          categories: project.project_categories.all.map(&:title).compact,
          react_count: project.react_count
        }
      end.compact
    end

    def features_data
      current_user.features.all.map do |feature|
        {
          id: feature.id,
          title: feature.title,
          description: feature.description,
          icon: (url_for(feature.icon) if feature.icon.attached?)
        }
      end.compact
    end

    def blogs_data
      current_user.blogs.all.map do |blog|
        {
          id: blog.id,
          title: blog.title,
          body: blog.body,
          image: url_for(blog.image),
          reading_time: blog.reading_time,
          category: blog.blog_categories.all.map(&:title)&.compact,
        }
      end.compact
    end

    def resume_data
      {
        education: current_user.education_histories.all.map do |education|
          { institution: education.institution,
            degree: education.degree,
            grade: education.grade,
            currently_enrolled: education.currently_enrolled,
            visibility: false,
            start_date: education.start_date.strftime('%d %b, %Y'),
            end_date: education.end_date.strftime('%d %b, %Y'),
            description: 'Contrary to popular belief. Ut tincidunt est ac dolor aliquam sodales. Phasellus sed mauris hendrerit, laoreet sem in, lobortis mauris hendrerit ante.'
          }
        end.compact,
        skills: current_user.users_skills.map do |users_skill|
          { id: users_skill.id, name: users_skill.skill.title, rating: users_skill.rating }
        end.compact,
        experience: current_user.work_histories.map do |work|
          {
            title: work.title,
            employment_type: work.employment_type,
            company_name: work.company_name,
            description: work.description,
            start_date: work.start_date.strftime('%d %b, %Y'),
            end_date: work.end_date.strftime('%d %b, %Y'),
            currently_employed: work.currently_employed,
            visibility: work.visibility
          }
        end.compact
      }
    end

    def contacts_data
      {
        first_name: current_user.first_name,
        last_name: current_user.last_name,
        email: current_user.email,
        designation: current_user.user_profile.designation,
        description: current_user.user_profile.contact_info,
        phone: current_user.phone
      }
    end

  end
end

