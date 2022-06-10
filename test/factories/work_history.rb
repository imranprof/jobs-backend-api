FactoryBot.define do
  factory :work_history do
    user
    title {}
    description do
      'Contrary to popular belief. Ut tincidunt est ac dolor aliquam sodales.'\
                      ' Phasellus sed mauris hendrerit, laoreet sem in, lobortis mauris hendrerit ante.'
    end
    employment_type {}
    company_name {}
    start_date {}
    end_date {}
    currently_employed {}
    visibility {}
  end
end
