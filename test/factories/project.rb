FactoryBot.define do
  factory :project do
    user
    title {}
    description do
      'Lorem ipsum dolor sit amet consectetur adipisicing elit.'\
                      ' Cupiditate distinctio assumenda explicabo veniam temporibus eligendi.'
    end
    live_url { '#' }
    source_url { '#' }
    react_count { 0 }
    transient do
      filename {}
    end
    after(:build) do |project, evaluator|
      project.image.attach(io: File.open(Rails.root.join("app/assets/images/projects/#{evaluator.filename}")),
                           filename: evaluator.filename)
    end
    after(:create) do |project|
      project.categorizations.create!(category: Category.order(Arel.sql('RANDOM()')).first)
    end
  end
end

