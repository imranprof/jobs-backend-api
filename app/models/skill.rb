class Skill < ApplicationRecord
  has_many :users_skills, dependent: :destroy
  has_one_attached :icon, dependent: :destroy

  validate :check_icon_presence

  def check_icon_presence
    errors.add(:icon, 'no image added') unless icon.attached?
  end
end
