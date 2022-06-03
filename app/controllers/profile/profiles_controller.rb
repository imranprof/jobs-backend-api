module Profile
  class ProfilesController < ApplicationController
    def show
      render json: data, status: :ok
    end

    def create_profile(user_id)
      @current_user = User.find_by(id: user_id)
      default_profile
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
          categories: project.project_categories.all.map do |project_category|
            { id: project_category.id, category_id: project_category.category_id,
              title: project_category.title }
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
          categories: blog.blog_categories.all.map do |blog_category|
            { id: blog_category.id, category_id: blog_category.category_id,
              title: blog_category.title }
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
            description: education.description
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
                                                         { project_categories_attributes: %i[id _destroy category_id] }],
                                   blogs_attributes: [:id, :title, :body, :reading_time, :image, :_destroy,
                                                      { blog_categories_attributes: %i[id category_id _destroy] }],
                                   education_histories_attributes: %i[id institution degree grade description _destroy
                                                                      start_date end_date currently_enrolled visibility],
                                   work_histories_attributes: %i[id title employment_type company_name description _destroy
                                                                 start_date end_date currently_employed visibility])
    end

    def default_profile
      user_profile = @current_user.create_user_profile(
        headline: 'WELCOME TO MY WORLD',
        title: "Hi, I'm",
        bio: 'I use animation as a third dimension by which to simplify experiences and
              kuiding thro each and every interaction. I’m not adding motion just to spruce things up,
              but doing it in ways that.',
        identity_number: '202219998',
        gender: 0,
        religion: 0,
        designation: 'Chief operating officer',
        contact_info: 'I am available for freelance work. Connect with me via and call in to my account.',
        contact_email: 'contact@adittorehan.com'
      )
      user_profile.avatar.attach(io: File.open(Rails.root.join('app/assets/images/default-avatar.png')),
                                 filename: 'default-avatar.png')
      user_profile.save
      user_profile.expertises.push('Program')
      user_profile.expertises.push('Rails Developer')
      user_profile.expertises.push('Programmer')
      user_profile.expertises.push('Designer')
      user_profile.expertises.push('Professional Coder')
      user_profile.save
      user_profile.create_social_link(facebook_url: 'facebook.com', github_url: 'github.com',
                                      linkedin_url: 'linkedin.com')
      skill = Skill.create(title: 'Ruby')
      skill.icon.attach(io: File.open(Rails.root.join('app/assets/images/skill/ruby.png')),
                        filename: 'ruby.png')
      skill.save
      UsersSkill.create!(rating: 100, user_id: @current_user.id, skill_id: skill.id)
      skill = Skill.create(title: 'Javascript')
      skill.icon.attach(io: File.open(Rails.root.join('app/assets/images/skill/javascript.png')),
                        filename: 'javascript.png')
      skill.save
      UsersSkill.create!(rating: 73, user_id: @current_user.id, skill_id: skill.id)
      skill = Skill.create(title: 'Python')
      skill.icon.attach(io: File.open(Rails.root.join('app/assets/images/skill/python.png')),
                        filename: 'python.png')
      skill.save
      UsersSkill.create!(rating: 90, user_id: @current_user.id, skill_id: skill.id)
      feature = @current_user.features.create(title: 'business strategy',
                                              description: 'I throw myself down among the tall grass by the stream as
                                                            I lie close to the earth.')
      feature.save
      feature = @current_user.features.create(title: 'app development',
                                              description: 'I throw myself down among the tall grass by the stream as
                                                            I lie close to the earth.')
      feature.save
      feature = @current_user.features.create(title: 'app design',
                                              description: 'I throw myself down among the tall grass by the stream as
                                                            I lie close to the earth.')
      feature.save
      feature = @current_user.features.create(title: 'mobile app',
                                              description: 'I throw myself down among the tall grass by the stream as
                                                            I lie close to the earth.')
      feature.save
      feature = @current_user.features.create(title: 'CEO marketing',
                                              description: 'I throw myself down among the tall grass by the stream as
                                                            I lie close to the earth.')
      feature.save
      feature = @current_user.features.create(title: 'UI & UX design',
                                              description: 'I throw myself down among the tall grass by the stream as
                                                            I lie close to the earth.')
      feature.save
      Category.create!(title: 'application')
      Category.create!(title: 'development')
      Category.create!(title: 'photoshop')
      Category.create!(title: 'figma')
      Category.create!(title: 'web design')

      project = @current_user.projects.create(
        title: 'The services provide for design',
        description: 'Lorem ipsum dolor sit amet consectetur adipisicing elit. Cupiditate distinctio
                      assumenda explicabo veniam temporibus eligendi.',
        live_url: '#',
        source_url: '#',
        react_count: 600
      )
      project.image.attach(io: File.open(Rails.root.join('app/assets/images/projects/portfolio-01.jpg')),
                           filename: 'portfolio-01.jpg')
      project.save
      ProjectCategory.create!(project_id: project.id, category_id: Category.all[0].id)
      ProjectCategory.create!(project_id: project.id, category_id: Category.all[1].id)
      project = @current_user.projects.create(
        title: 'The services provide for design',
        description: 'Lorem ipsum dolor sit amet consectetur adipisicing elit.
                      Cupiditate distinctio assumenda explicabo veniam temporibus eligendi.',
        live_url: '#',
        source_url: '#',
        react_count: 600
      )
      project.image.attach(io: File.open(Rails.root.join('app/assets/images/projects/portfolio-02.jpg')),
                           filename: 'portfolio-02.jpg')
      project.save
      ProjectCategory.create!(project_id: project.id, category_id: Category.all[1].id)
      project = @current_user.projects.create(
        title: 'Mobile app landing design & app maintain',
        description: 'Lorem ipsum dolor sit amet consectetur adipisicing elit.
                      Cupiditate distinctio assumenda explicabo veniam temporibus eligendi.',
        live_url: '#',
        source_url: '#',
        react_count: 750
      )
      project.image.attach(io: File.open(Rails.root.join('app/assets/images/projects/portfolio-03.jpg')),
                           filename: 'portfolio-03.jpg')
      project.save
      ProjectCategory.create!(project_id: project.id, category_id: Category.all[2].id)
      project = @current_user.projects.create(
        title: 'Logo design creativity & application',
        description: 'Lorem ipsum dolor sit amet consectetur adipisicing elit.
                      Cupiditate distinctio assumenda explicabo veniam temporibus eligendi.',
        live_url: '#',
        source_url: '#',
        react_count: 630
      )
      project.image.attach(io: File.open(Rails.root.join('app/assets/images/projects/portfolio-04.jpg')),
                           filename: 'portfolio-04.jpg')
      project.save
      ProjectCategory.create!(project_id: project.id, category_id: Category.all[4].id)
      @current_user.education_histories.create!(
        institution: 'University of A',
        degree: 'diploma',
        grade: 'B',
        description: 'The education should be very interactual. Ut tincidunt est ac dolor aliquam sodales.
                      Phasellus sed mauris hendrerit, laoreet sem in, lobortis mauris hendrerit ante.',
        start_date: DateTime.iso8601('2016-01-01', Date::ENGLAND),
        end_date: DateTime.iso8601('2018-01-01', Date::ENGLAND),
        currently_enrolled: false,
        visibility: true
      )
      @current_user.education_histories.create!(
        institution: 'University of B',
        degree: 'bachelor',
        grade: 'A',
        description: 'The education should be very interactual. Ut tincidunt est ac dolor aliquam sodales.
                      Phasellus sed mauris hendrerit, laoreet sem in, lobortis mauris hendrerit ante.',
        start_date: DateTime.iso8601('2018-01-01', Date::ENGLAND),
        end_date: DateTime.iso8601('2022-01-01', Date::ENGLAND),
        currently_enrolled: false,
        visibility: true
      )
      @current_user.work_histories.create!(
        title: 'Diploma in Web Development',
        employment_type: 0,
        company_name: 'Company A',
        description: 'Contrary to popular belief. Ut tincidunt est ac dolor aliquam sodales.
                      Phasellus sed mauris hendrerit, laoreet sem in, lobortis mauris hendrerit ante.',
        start_date: DateTime.iso8601('2018-01-01', Date::ENGLAND),
        end_date: DateTime.iso8601('2020-01-01', Date::ENGLAND),
        currently_employed: true,
        visibility: true
      )
      @current_user.work_histories.create!(
        title: 'The Personal Portfolio Mystery',
        employment_type: 0,
        company_name: 'Company B',
        description: 'Contrary to popular belief. Ut tincidunt est ac dolor aliquam sodales.
                      Phasellus sed mauris hendrerit, laoreet sem in, lobortis mauris hendrerit ante.',
        start_date: DateTime.iso8601('2020-01-01', Date::ENGLAND),
        end_date: DateTime.iso8601(DateTime.now.strftime('%Y-%m-%d'), Date::ENGLAND),
        currently_employed: true,
        visibility: true
      )
      blog = @current_user.blogs.create(
        title: 'The services provide for design',
        body: 'Nobis eleifend option congue nihil imperdiet doming id quod mazim placerat
                facer possim assum. Typi non habent claritatem insitam; est usus legentis in iis qui facit eorum
                claritatem. Investigationes demonstraverunt lectores legere me lius quod ii legunt saepius.
                Claritas est etiam processus dynamicus, qui sequitur mutationem consuetudium lectorum.',
        reading_time: 120
      )
      blog.image.attach(io: File.open(Rails.root.join('app/assets/images/blogs/blog-01.jpg')),
                        filename: 'blog-01.jpg')
      blog.save
      BlogCategory.create!(blog_id: blog.id, category_id: Category.all[0].id)
      blog = @current_user.blogs.create(
        title: 'Mobile app landing design & app maintain',
        body: 'Nobis eleifend option congue nihil imperdiet doming id quod mazim placerat
                facer possim assum. Typi non habent claritatem insitam; est usus legentis in iis qui facit eorum
                claritatem. Investigationes demonstraverunt lectores legere me lius quod ii legunt saepius.
                Claritas est etiam processus dynamicus, qui sequitur mutationem consuetudium lectorum.',
        reading_time: 120
      )
      blog.image.attach(io: File.open(Rails.root.join('app/assets/images/blogs/blog-02.jpg')),
                        filename: 'blog-02.jpg')
      blog.save
      BlogCategory.create!(blog_id: blog.id, category_id: Category.all[1].id)
      blog = @current_user.blogs.create(
        title: 'T-shirt design is the part of design',
        body: 'Nobis eleifend option congue nihil imperdiet doming id quod mazim placerat
                facer possim assum. Typi non habent claritatem insitam; est usus legentis in iis qui facit eorum
                claritatem. Investigationes demonstraverunt lectores legere me lius quod ii legunt saepius.
                Claritas est etiam processus dynamicus, qui sequitur mutationem consuetudium lectorum.',
        reading_time: 120
      )
      blog.image.attach(io: File.open(Rails.root.join('app/assets/images/blogs/blog-03.jpg')),
                        filename: 'blog-03.jpg')
      blog.save
      BlogCategory.create!(blog_id: blog.id, category_id: Category.all[2].id)
    end
  end
end
