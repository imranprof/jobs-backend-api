class UserProfile < ApplicationRecord
  include ActiveStorageSupport::SupportForBase64

  belongs_to :user
  has_one :social_link, dependent: :destroy
  has_one_base64_attached :avatar, dependent: :destroy
  validate :check_avatar_presence
  validates :headline, :title, :bio, :identity_number, :gender, :location, :designation, :contact_info, presence: true
  accepts_nested_attributes_for :social_link, allow_destroy: true
  before_create :set_slug

  PAGINATION_LIMIT = 8

  def check_avatar_presence
    errors.add(:avatar, 'no file added') unless avatar.attached?
  end

  def count_rating
    total_rating = user.job_applications.Closed.rated.sum(:employer_rating).to_f
    total_job = user.job_applications.Closed.rated.count
    return 0 if total_job.zero? || total_rating.zero?

    (total_rating / total_job)
  end

  def set_slug
    slug = "#{user.first_name}-#{user.last_name}".downcase
    slug += "-#{user_id}" if UserProfile.find_by(slug: slug)
    self[:slug] = slug
  end
end
