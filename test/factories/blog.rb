FactoryBot.define do
  factory :blog do
    user
    title {}
    body do
      'Nobis eleifend option congue nihil imperdiet doming id quod mazim placerat'\
                ' facer possim assum. Typi non habent claritatem insitam; est usus legentis in iis qui facit eorum'\
                ' claritatem. Investigationes demonstraverunt lectores legere me lius quod ii legunt saepius.'\
                ' Claritas est etiam processus dynamicus, qui sequitur mutationem consuetudium lectorum.'
    end
    reading_time { rand(60...400) }
    transient do
      filename {}
    end
    after(:build) do |blog, evaluator|
      blog.image.attach(io: File.open(Rails.root.join("app/assets/images/blogs/#{evaluator.filename}")),
                        filename: evaluator.filename)
    end
    after(:create) do |blog|
      blog.categorizations.create!(category: Category.order(Arel.sql('RANDOM()')).first)
    end
  end
end

