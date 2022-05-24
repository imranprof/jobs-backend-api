class Project < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  has_many :project_categories, dependent: :destroy

  validate :check_image_presence

  def check_image_presence
    errors.add(:image, 'no image added') unless image.attached?
  end
end
