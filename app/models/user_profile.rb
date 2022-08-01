class UserProfile < ApplicationRecord
  belongs_to :user
  has_one :social_link, dependent: :destroy
  has_one_attached :avatar, dependent: :destroy
  validate :check_avatar_presence
  validates :headline, :title, :bio, :identity_number, :gender, :religion, :designation, :contact_info, presence: true
  accepts_nested_attributes_for :social_link, allow_destroy: true
  before_create :set_slug

  def check_avatar_presence
    errors.add(:avatar, 'no file added') unless avatar.attached?
  end

  def set_slug
    slug = "#{user.first_name}-#{user.last_name}".downcase
    slug += "-#{user_id}" if UserProfile.find_by(slug: slug)
    self[:slug] = slug
  end
end
