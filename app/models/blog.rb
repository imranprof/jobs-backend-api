class Blog < ApplicationRecord
  include ActiveStorageSupport::SupportForBase64

  belongs_to :user
  has_one_base64_attached :image, dependent: :destroy
  has_many :categorizations, as: :categorizable, dependent: :destroy
  has_many :categories, through: :categorizations
  accepts_nested_attributes_for :categorizations, allow_destroy: true

  before_create :save_default_image
  validates :title, :body, :reading_time, presence: true

  private

  def save_default_image
    unless image.attached?
      image.attach(io: File.open(Rails.root.join('app/assets/images/blogs/blog-01.jpg')),
                   filename: 'blog-01.jpg')
    end
  end
end
