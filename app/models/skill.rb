class Skill < ApplicationRecord
  include ActiveStorageSupport::SupportForBase64

  has_many :users_skills, dependent: :destroy
  has_many :users, through: :users_skills
  has_one_base64_attached :icon, dependent: :destroy

  before_create :save_default_icon
  validates :title, presence: true

  private

  def save_default_icon
    unless icon.attached?
      icon.attach(io: File.open(Rails.root.join('app/assets/images/skill/default-skill-icon.png')),
                  filename: 'default-skill-icon.png')
    end
  end
end
