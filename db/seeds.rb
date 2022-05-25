user = User.create!(
  first_name: 'Aditto',
  last_name: 'Rehan',
  email: 'adittorehan@hotmail.com',
  password: 'Test1234*',
  password_confirmation: 'Test1234*',
  phone: '+8801892445308'
)
puts '#1: Created User'

user_profile = user.create_user_profile(
  headline: 'WELCOME TO MY WORLD',
  title: "Hi, I'm",
  bio: 'I use animation as a third dimension by which to simplify experiences and kuiding thro each and every interaction. I’m not adding motion just to spruce things up, but doing it in ways that.',
  identity_number: '202219998',
  gender: 0,
  religion: 0,
  designation: 'Chief operating officer',
  contact_info: 'I am available for freelance work. Connect with me via and call in to my account.',
  contact_email: 'contact@adittorehan.com'
)
puts '#2: Created User Profile'

user_profile.avatar.attach(io: File.open(Rails.root.join('app/assets/images/default-avatar.png')),
                           filename: 'default-avatar.png'
)
user_profile.save
user_profile.create_social_link(facebook_url: 'facebook.com', github_url: 'github.com',
                                       linkedin_url: 'linkedin.com')
puts '#3: Added Default Avatar'

user_profile.expertises.push('Program')
user_profile.expertises.push('Rails Developer')
user_profile.expertises.push('Programmer')
user_profile.expertises.push('Designer')
user_profile.expertises.push('Professional Coder')
user_profile.save
puts '#4: Added Expertises'

skill = Skill.create(title: 'Ruby')
skill.icon.attach(io: File.open(Rails.root.join('app/assets/images/skill/ruby.png')),
                  filename: 'ruby.png'
)
skill.save
UsersSkill.create!(rating: 100, user_id: user.id, skill_id: skill.id)

skill = Skill.create(title: 'Javascript')
skill.icon.attach(io: File.open(Rails.root.join('app/assets/images/skill/javascript.png')),
                  filename: 'javascript.png'
)
skill.save
UsersSkill.create!(rating: 73, user_id: user.id, skill_id: skill.id)

skill = Skill.create(title: 'Python')
skill.icon.attach(io: File.open(Rails.root.join('app/assets/images/skill/python.png')),
                  filename: 'python.png'
)
skill.save
UsersSkill.create!(rating: 90, user_id: user.id, skill_id: skill.id)
puts '#5: Added Skills'
puts '#6: Associate Skills to User'

feature = user.features.create(title: 'business strategy',
                               description: 'I throw myself down among the tall grass by the stream as I lie close to the earth.')
feature.save
feature = user.features.create(title: 'app development',
                               description: 'I throw myself down among the tall grass by the stream as I lie close to the earth.')
feature.save
feature = user.features.create(title: 'app design',
                               description: 'I throw myself down among the tall grass by the stream as I lie close to the earth.')
feature.save
feature = user.features.create(title: 'mobile app',
                               description: 'I throw myself down among the tall grass by the stream as I lie close to the earth.')
feature.save
feature = user.features.create(title: 'CEO marketing',
                               description: 'I throw myself down among the tall grass by the stream as I lie close to the earth.')
feature.save
feature = user.features.create(title: 'UI & UX design',
                               description: 'It uses a dictionary of over 200 Latin words, combined with a handful of model sentence.')
feature.save
puts '#7: Added Features'

Category.create!(title: 'application')
Category.create!(title: 'development')
Category.create!(title: 'photoshop')
Category.create!(title: 'figma')
Category.create!(title: 'web design')

project = user.projects.create(
  title: 'The services provide for design',
  description: 'Lorem ipsum dolor sit amet consectetur adipisicing elit. Cupiditate distinctio assumenda explicabo veniam temporibus eligendi.',
  live_url: '#',
  source_url: '#',
  react_count: 600
)

project.image.attach(io: File.open(Rails.root.join('app/assets/images/projects/portfolio-01.jpg')),
                     filename: 'portfolio-01.jpg'
)
project.save
ProjectCategory.create!(project_id: project.id, category_id: Category.all[0].id)
ProjectCategory.create!(project_id: project.id, category_id: Category.all[1].id)

project = user.projects.create(
  title: 'The services provide for design',
  description: 'Lorem ipsum dolor sit amet consectetur adipisicing elit. Cupiditate distinctio assumenda explicabo veniam temporibus eligendi.',
  live_url: '#',
  source_url: '#',
  react_count: 600
)

project.image.attach(io: File.open(Rails.root.join('app/assets/images/projects/portfolio-02.jpg')),
                     filename: 'portfolio-02.jpg'
)
project.save
ProjectCategory.create!(project_id: project.id, category_id: Category.all[1].id)

project = user.projects.create(
  title: 'Mobile app landing design & app maintain',
  description: 'Lorem ipsum dolor sit amet consectetur adipisicing elit. Cupiditate distinctio assumenda explicabo veniam temporibus eligendi.',
  live_url: '#',
  source_url: '#',
  react_count: 750
)

project.image.attach(io: File.open(Rails.root.join('app/assets/images/projects/portfolio-03.jpg')),
                     filename: 'portfolio-03.jpg'
)
project.save
ProjectCategory.create!(project_id: project.id, category_id: Category.all[2].id)

project = user.projects.create(
  title: 'Logo design creativity & application',
  description: 'Lorem ipsum dolor sit amet consectetur adipisicing elit. Cupiditate distinctio assumenda explicabo veniam temporibus eligendi.',
  live_url: '#',
  source_url: '#',
  react_count: 630
)

project.image.attach(io: File.open(Rails.root.join('app/assets/images/projects/portfolio-04.jpg')),
                     filename: 'portfolio-04.jpg'
)
project.save
ProjectCategory.create!(project_id: project.id, category_id: Category.all[4].id)

puts '#8: Added Projects'

puts '#9: Added Educations'
user.education_histories.create!(
  institution: 'University of A',
  degree: 'diploma',
  grade: 'B',
  description: 'The education should be very interactual. Ut tincidunt est ac dolor aliquam sodales. Phasellus sed mauris hendrerit, laoreet sem in, lobortis mauris hendrerit ante.',
  start_date: DateTime.iso8601('2016-01-01', Date::ENGLAND),
  end_date: DateTime.iso8601('2018-01-01', Date::ENGLAND),
  currently_enrolled: false,
  visibility: true
)

user.education_histories.create!(
  institution: 'University of B',
  degree: 'bachelor',
  grade: 'A',
  description: 'The education should be very interactual. Ut tincidunt est ac dolor aliquam sodales. Phasellus sed mauris hendrerit, laoreet sem in, lobortis mauris hendrerit ante.',
  start_date: DateTime.iso8601('2018-01-01', Date::ENGLAND),
  end_date: DateTime.iso8601('2022-01-01', Date::ENGLAND),
  currently_enrolled: false,
  visibility: true
)
puts '#11: Added Experiences'
user.work_histories.create!(
  title: 'Diploma in Web Development',
  employment_type: 0,
  company_name: 'Company A',
  description: 'Contrary to popular belief. Ut tincidunt est ac dolor aliquam sodales. Phasellus sed mauris hendrerit, laoreet sem in, lobortis mauris hendrerit ante.',
  start_date: DateTime.iso8601('2018-01-01', Date::ENGLAND),
  end_date: DateTime.iso8601('2020-01-01', Date::ENGLAND),
  currently_employed: true,
  visibility: true
)

user.work_histories.create!(
  title: 'The Personal Portfolio Mystery',
  employment_type: 0,
  company_name: 'Company B',
  description: 'Contrary to popular belief. Ut tincidunt est ac dolor aliquam sodales. Phasellus sed mauris hendrerit, laoreet sem in, lobortis mauris hendrerit ante.',
  start_date: DateTime.iso8601('2020-01-01', Date::ENGLAND),
  end_date: DateTime.iso8601(DateTime.now.strftime('%Y-%m-%d'), Date::ENGLAND),
  currently_employed: true,
  visibility: true
)
puts '#12: Added Blogs'

blog = user.blogs.create(
  title: 'The services provide for design',
  body: 'Nobis eleifend option congue nihil imperdiet doming id quod mazim placerat
                facer
                possim assum.
                Typi non
                habent claritatem insitam; est usus legentis in iis qui facit eorum
                claritatem.
                Investigationes
                demonstraverunt
                lectores legere me lius quod ii legunt saepius. Claritas est etiam processus
                dynamicus, qui
                sequitur
                mutationem consuetudium lectorum.',
  reading_time: 120,
)

blog.image.attach(io: File.open(Rails.root.join('app/assets/images/blogs/blog-01.jpg')),
                  filename: 'blog-01.jpg'
)

blog.save
BlogCategory.create!(blog_id: blog.id, category_id: Category.all[0].id)

blog = user.blogs.create(
  title: 'Mobile app landing design & app maintain',
  body: 'Nobis eleifend option congue nihil imperdiet doming id quod mazim placerat
                facer
                possim assum.
                Typi non
                habent claritatem insitam; est usus legentis in iis qui facit eorum
                claritatem.
                Investigationes
                demonstraverunt
                lectores legere me lius quod ii legunt saepius. Claritas est etiam processus
                dynamicus, qui
                sequitur
                mutationem consuetudium lectorum.',
  reading_time: 120,
)

blog.image.attach(io: File.open(Rails.root.join('app/assets/images/blogs/blog-02.jpg')),
                  filename: 'blog-02.jpg'
)

blog.save
BlogCategory.create!(blog_id: blog.id, category_id: Category.all[1].id)

blog = user.blogs.create(
  title: 'T-shirt design is the part of design',
  body: 'Nobis eleifend option congue nihil imperdiet doming id quod mazim placerat
                facer
                possim assum.
                Typi non
                habent claritatem insitam; est usus legentis in iis qui facit eorum
                claritatem.
                Investigationes
                demonstraverunt
                lectores legere me lius quod ii legunt saepius. Claritas est etiam processus
                dynamicus, qui
                sequitur
                mutationem consuetudium lectorum.',
  reading_time: 120,
)

blog.image.attach(io: File.open(Rails.root.join('app/assets/images/blogs/blog-03.jpg')),
                  filename: 'blog-03.jpg'
)

blog.save
BlogCategory.create!(blog_id: blog.id, category_id: Category.all[2].id)
