class Project < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  has_many :categorizations, as: :categorizable, dependent: :destroy
  has_many :categories, through: :categorizations
  accepts_nested_attributes_for :categorizations, allow_destroy: true

  validate :check_image_presence
  validates :title, :description, :live_url, :source_url, :react_count, presence: true

  def check_image_presence
    errors.add(:image, 'no image added') unless image.attached?
  end
end
