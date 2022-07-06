FactoryBot.define do
  factory :social_link do
    user_profile
    facebook { 'facebook.com' }
    github { 'github.com' }
    linkedin { 'linkedin.com' }
  end
end

