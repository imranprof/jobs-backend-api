FactoryBot.define do
  factory :social_link do
    user_profile
    facebook { 'https://www.facebook.com' }
    github { 'https://www.github.com' }
    linkedin { 'https://www.linkedin.com' }
  end
end
