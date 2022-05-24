class Skill < ApplicationRecord
  has_many :users_skills, dependent: :destroy
end
