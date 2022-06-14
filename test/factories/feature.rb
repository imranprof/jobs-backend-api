FactoryBot.define do
  factory :feature do
    user
    title {}
    description do
      'I throw myself down among the tall grass by the stream as'\
                                                            ' I lie close to the earth.'
    end
  end
end
