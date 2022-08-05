FactoryBot.define do
  factory :user_profile do
    user
    headline { 'WELCOME TO MY WORLD' }
    title { "Hi, I'm" }
    bio do
      'Your profile Bio should contain a short detail of your work experience. '\
      'Write about the experiences that are relevant to the services you are offering. '\
      'While it’s important to keep the bio professional.'
    end
    identity_number { '202219998' }
    gender { 0 }
    religion { 0 }
    designation { 'Your designation here. E.g. \'Certified Supply Chain Professional\'' }
    contact_info { 'I\'d love to hear from you! Send me a question and i\'ll be in touch you as soon as possible' }
    contact_email { user.email }
    expertises { ['Problem Solver', 'Creative Thinker'] }
    after(:build) do |user_profile|
      user_profile.avatar.attach(io: File.open(Rails.root.join('app/assets/images/default-avatar.png')),
                                 filename: 'default-avatar.png')
    end
    after(:create) do |user_profile|
      FactoryBot.create(:social_link, user_profile: user_profile)
    end
  end

end
