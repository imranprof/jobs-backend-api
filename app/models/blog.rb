class Blog < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  has_many :categorizations, as: :categorizable, dependent: :destroy
  has_many :categories, through: :categorizations
  accepts_nested_attributes_for :categorizations, allow_destroy: true

  before_save :save_default_image
  validates :title, :body, :reading_time, presence: true

  private

  def save_default_image
    unless image.attached?
      image.attach(io: File.open(Rails.root.join('app/assets/images/blogs/blog-01.jpg')),
                   filename: 'blog-01.jpg')
    end
  end
end
