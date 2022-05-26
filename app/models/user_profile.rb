class UserProfile < ApplicationRecord
  belongs_to :user
  has_one :social_link, dependent: :destroy
  has_one_attached :avatar, dependent: :destroy
  validate :check_avatar_presence
  accepts_nested_attributes_for :social_link, allow_destroy: true

  def check_avatar_presence
    errors.add(:avatar, "no file added") unless avatar.attached?
  end
end
