class Project < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  has_many :project_categories, dependent: :destroy
  accepts_nested_attributes_for :project_categories, allow_destroy: true

  validate :check_image_presence

  def check_image_presence
    errors.add(:image, 'no image added') unless image.attached?
  end
end
