class UserProfile < ApplicationRecord
  belongs_to :user
  has_one :social_link
  has_many :expertises
end
