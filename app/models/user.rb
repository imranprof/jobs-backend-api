# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }
  validates :password, confirmation: true

  has_many :user_contacts
  has_many :users_skills, dependent: :destroy
  has_many :skills, through: :users_skills
  has_many :features, dependent: :destroy
  has_many :blogs, dependent: :destroy
  has_many :projects, dependent: :destroy
  has_many :education_histories, dependent: :destroy
  has_many :work_histories, dependent: :destroy
  has_one :user_profile, dependent: :destroy
  accepts_nested_attributes_for :user_profile, :features, :users_skills, :projects, :blogs, :education_histories,
                                :work_histories, reject_if: :all_blank, allow_destroy: true

  after_create :default_user_profile

  private

  def default_user_profile
    user_profile = create_user_profile(
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
    user_profile.contact_email = email
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
    users_skills.create!(rating: 100, skill: skill)
    skill = Skill.create(title: 'Javascript')
    skill.icon.attach(io: File.open(Rails.root.join('app/assets/images/skill/javascript.png')),
                      filename: 'javascript.png')
    skill.save
    users_skills.create!(rating: 73, skill: skill)
    skill = Skill.create(title: 'Python')
    skill.icon.attach(io: File.open(Rails.root.join('app/assets/images/skill/python.png')),
                      filename: 'python.png')
    skill.save
    users_skills.create!(rating: 90, skill: skill)
    feature = features.create(title: 'business strategy',
                              description: 'I throw myself down among the tall grass by the stream as
                                                            I lie close to the earth.')
    feature.save
    feature = features.create(title: 'app development',
                              description: 'I throw myself down among the tall grass by the stream as
                                                            I lie close to the earth.')
    feature.save
    feature = features.create(title: 'app design',
                              description: 'I throw myself down among the tall grass by the stream as
                                                            I lie close to the earth.')
    feature.save
    feature = features.create(title: 'mobile app',
                              description: 'I throw myself down among the tall grass by the stream as
                                                            I lie close to the earth.')
    feature.save
    feature = features.create(title: 'CEO marketing',
                              description: 'I throw myself down among the tall grass by the stream as
                                                            I lie close to the earth.')
    feature.save
    feature = features.create(title: 'UI & UX design',
                              description: 'I throw myself down among the tall grass by the stream as
                                                            I lie close to the earth.')
    feature.save
    Category.create!(title: 'application')
    Category.create!(title: 'development')
    Category.create!(title: 'photoshop')
    Category.create!(title: 'figma')
    Category.create!(title: 'web design')

    project = projects.create(
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
    project.categorizations.create!(category: Category.all[0])
    project.categorizations.create!(category: Category.all[1])
    project = projects.create(
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
    project.categorizations.create!(category: Category.all[1])
    project = projects.create(
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
    project.categorizations.create!(category: Category.all[2])
    project = projects.create(
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
    project.categorizations.create!(category: Category.all[4])
    education_histories.create!(
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
    education_histories.create!(
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
    work_histories.create!(
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
    work_histories.create!(
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
    blog = blogs.create(
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
    blog.categorizations.create!(category: Category.all[0])
    blog = blogs.create(
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
    blog.categorizations.create!(category: Category.all[1])
    blog = blogs.create(
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
    blog.categorizations.create!(category: Category.all[2])
  end
end
