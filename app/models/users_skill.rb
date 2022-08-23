class UsersSkill < ApplicationRecord
  belongs_to :user
  belongs_to :skill

  validates_uniqueness_of :skill_id, scope: [:user_id]

  private

  def initialize(attributes = nil)
    if attributes && attributes[:skill_title]
      skill = Skill.create(title: attributes[:skill_title], custom_skill: true)
      attributes[:skill_id] = skill.id
      attributes.delete(:skill_title)
    end
    super
  end
end
