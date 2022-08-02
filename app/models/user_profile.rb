class UserProfile < ApplicationRecord
  include ActiveStorageSupport::SupportForBase64

  belongs_to :user
  has_one :social_link, dependent: :destroy
  has_one_base64_attached :avatar, dependent: :destroy
  validate :check_avatar_presence
  validates :headline, :title, :bio, :identity_number, :gender, :religion, :designation, :contact_info, presence: true
  accepts_nested_attributes_for :social_link, allow_destroy: true

  def check_avatar_presence
    errors.add(:avatar, 'no file added') unless avatar.attached?
  end
end
