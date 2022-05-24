class Feature < ApplicationRecord
  belongs_to :user
  has_one_attached :icon

  validate :check_file_presence

  def check_file_presence
    errors.add(:icon, "no file added") unless icon.attached?
  end
end
