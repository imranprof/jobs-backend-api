FactoryBot.define do
  factory :education_history do
    user
    institution {}
    degree {}
    grade {}
    description do
      'The education should be very interactual. Ut tincidunt est ac dolor aliquam sodales.'\
                      ' Phasellus sed mauris hendrerit, laoreet sem in, lobortis mauris hendrerit ante.'
    end
    start_date {}
    end_date {}
    currently_enrolled { false }
    visibility { true }
  end
end
