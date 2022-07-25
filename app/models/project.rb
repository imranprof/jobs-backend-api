class Project < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  has_many :categorizations, as: :categorizable, dependent: :destroy
  has_many :categories, through: :categorizations
  accepts_nested_attributes_for :categorizations, allow_destroy: true

  before_save :save_default_image
  validates :title, :description, :live_url, :source_url, :react_count, presence: true

  private

  def save_default_image
    unless image.attached?
      image.attach(io: File.open(Rails.root.join('app/assets/images/projects/portfolio-01.jpg')),
                   filename: 'portfolio-01.jpg')
    end
  end
end
