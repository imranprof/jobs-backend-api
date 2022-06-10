FactoryBot.define do
  factory :social_link do
    user_profile
    facebook_url { 'facebook.com' }
    github_url { 'github.com' }
    linkedin_url { 'linkedin.com' }
  end
end

