class Blog < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  has_many :blog_categories, dependent: :destroy

  validate :check_image_presence
  private

  def check_image_presence
    errors.add('no image found') unless image.attached?
  end
end
