# frozen_string_literal: true

require 'factory_bot'

skill_list = [
  { title: :Ruby, filename: 'ruby.png', icon_path: 'app/assets/images/skill/ruby.png' },
  { title: :Javascript, filename: 'javascript.png', icon_path: 'app/assets/images/skill/javascript.png' },
  { title: :Python, filename: 'python.png', icon_path: 'app/assets/images/skill/python.png' },
  { title: :Golang, filename: 'golang.png', icon_path: 'app/assets/images/skill/golang.png' },
  { title: :Java, filename: 'java.png', icon_path: 'app/assets/images/skill/java.png' }
]
skill_list.each do |skill|
  FactoryBot.create(:skill, title: skill[:title], filename: skill[:filename])
end

Category.create!(title: 'application')
Category.create!(title: 'development')
Category.create!(title: 'photoshop')
Category.create!(title: 'figma')
Category.create!(title: 'web design')
