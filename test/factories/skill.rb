FactoryBot.define do
  factory :skill do
    transient do
      filename {}
    end
    after(:build) do |skill, evaluator|
      skill.icon.attach(io: File.open(Rails.root.join("app/assets/images/skill/#{evaluator.filename}")),
                        filename: evaluator.filename)
    end
  end
end
