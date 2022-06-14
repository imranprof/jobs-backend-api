class Feature < ApplicationRecord
  belongs_to :user
  has_one_attached :icon

  validates :title, :description, presence: true
end
