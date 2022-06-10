FactoryBot.define do
  factory :users_skill do
    user
    skill
    rating { 0 }
  end
end