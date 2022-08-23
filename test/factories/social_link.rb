FactoryBot.define do
  factory :social_link do
    user_profile
    facebook { '' }
    github { '' }
    linkedin { '' }
  end
end
