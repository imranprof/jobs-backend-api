class UserProfile < ApplicationRecord
  belongs_to :user
  has_one :social_link, dependent: :destroy
  has_one_attached :avatar, dependent: :destroy
  validate :check_avatar_presence

  def check_avatar_presence
    errors.add(:avatar, "no file added") unless avatar.attached?
  end
end
