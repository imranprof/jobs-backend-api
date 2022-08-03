FactoryBot.define do
  factory :user_profile do
    user
    headline { 'WELCOME TO MY WORLD' }
    title { "Hi, I'm" }
    bio {
      'I use animation as a third dimension by which to simplify experiences and'\
              ' kuiding thro each and every interaction. I’m not adding motion just to spruce things up,'\
              ' but doing it in ways that.' }
    identity_number { '202219998' }
    gender { 0 }
    religion { 0 }
    designation { 'Chief operating officer' }
    contact_info { 'I am available for freelance work. Connect with me via and call in to my account.' }
    contact_email { user.email }
    expertises { ['Developer', 'Rails Developer', 'Programmer', 'Designer', 'Professional Coder'] }
    after(:build) do |user_profile|
      user_profile.avatar.attach(io: File.open(Rails.root.join('app/assets/images/default-avatar.png')),
                                 filename: 'default-avatar.png')
    end
    after(:create) do |user_profile|
      FactoryBot.create(:social_link, user_profile: user_profile)
    end
  end

end
