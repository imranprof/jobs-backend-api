module Profile
  class ProfilesController < ApplicationController
    def show
      render json: data, status: :ok
    end

    def create_profile(user_id)
      @current_user = User.find_by(id: user_id)
      show
    end

    def update
      if @current_user.update(profile_params)
        @current_user.reload
        show
      else
        render json: { message: 'Failed to update profile.' }, status: :bad_request
      end
    end

    private

    def data
      {
        profile_data: profile_data,
        features_data: features_data,
        portfolio_data: portfolio_data,
        resume_data: resume_data,
        blogs_data: blogs_data,
        contacts_data: contacts_data
      }
    end

    def profile_data
      profile = @current_user.user_profile
      {
        id: profile.id,
        first_name: profile.user.first_name,
        last_name: profile.user.last_name,
        headline: profile.headline,
        title: profile.title,
        bio: profile.bio,
        avatar: url_for(profile.avatar),
        expertises: profile.expertises,
        social_links: (
          if profile.social_link
            { id: profile.social_link.id, facebook_url: profile.social_link.facebook_url,
              github_url: profile.social_link.github_url, linkedin_url: profile.social_link.linkedin_url }
          end),
        skills: profile.user.users_skills.map do |users_skill|
          { id: users_skill.id, name: users_skill.skill.title, rating: users_skill.rating }
        end.compact
      }
    end

    def portfolio_data
      @current_user.projects.all.map do |project|
        {
          id: project.id,
          title: project.title,
          description: project.description,
          image: url_for(project.image),
          live_url: project.live_url,
          source_url: project.source_url,
          categories: project.categorizations.all.map do |project_category|
            { id: project_category.id, category_id: project_category.category_id,
              title: project_category.category.title }
          end.compact,
          react_count: project.react_count
        }
      end.compact
    end

    def features_data
      @current_user.features.all.map do |feature|
        {
          id: feature.id,
          title: feature.title,
          description: feature.description,
          icon: (url_for(feature.icon) if feature.icon.attached?)
        }
      end.compact
    end

    def blogs_data
      @current_user.blogs.all.map do |blog|
        {
          id: blog.id,
          title: blog.title,
          body: blog.body,
          image: url_for(blog.image),
          reading_time: blog.reading_time,
          categories: blog.categorizations.all.map do |blog_category|
            { id: blog_category.id, category_id: blog_category.category_id,
              title: blog_category.category.title }
          end.compact
        }
      end.compact
    end

    def resume_data
      {
        education: @current_user.education_histories.all.map do |education|
          {
            id: education.id,
            institution: education.institution,
            degree: education.degree,
            grade: education.grade,
            currently_enrolled: education.currently_enrolled,
            visibility: education.visibility,
            start_date: education.start_date.strftime('%d %b, %Y'),
            end_date: education.end_date.strftime('%d %b, %Y'),
            description: 'Contrary to popular belief. Ut tincidunt est ac dolor aliquam sodales. Phasellus sed mauris hendrerit, laoreet sem in, lobortis mauris hendrerit ante.'
          }
        end.compact,
        skills: @current_user.users_skills.map do |users_skill|
          { id: users_skill.id, name: users_skill.skill.title, rating: users_skill.rating }
        end.compact,
        experience: @current_user.work_histories.map do |work|
          {
            id: work.id,
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
        first_name: @current_user.first_name,
        last_name: @current_user.last_name,
        email: @current_user.email,
        designation: @current_user.user_profile.designation,
        description: @current_user.user_profile.contact_info,
        phone: @current_user.phone
      }
    end

    def profile_params
      params.require(:user).permit(:first_name, :last_name, :email, :phone, :password,
                                   user_profile_attributes: [:id, :headline, :title, :bio, :identity_number, :gender,
                                                             :religion, :designation, :contact_info, :contact_email,
                                                             :expertises, :avatar,
                                                             { social_link_attributes:
                                                                 %i[id facebook_url github_url linkedin_url _destroy] }],
                                   features_attributes: %i[id title description _destroy],
                                   users_skills_attributes: %i[id skill_id rating _destroy],
                                   projects_attributes: [:id, :title, :description, :live_url, :source_url,
                                                         :react_count, :image, :_destroy,
                                                         { categorizations_attributes: %i[id _destroy category_id] }],
                                   blogs_attributes: [:id, :title, :body, :reading_time, :image, :_destroy,
                                                      { categorizations_attributes: %i[id category_id _destroy] }],
                                   education_histories_attributes: %i[id institution degree grade description _destroy
                                                                      start_date end_date currently_enrolled visibility],
                                   work_histories_attributes: %i[id title employment_type company_name description _destroy
                                                                 start_date end_date currently_employed visibility])
    end
  end
end
