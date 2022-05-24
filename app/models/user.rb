# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }
  validates :password, confirmation: true

  has_many :user_contacts
  has_many :users_skills, dependent: :destroy
  has_many :features, dependent: :destroy
  has_many :blogs, dependent: :destroy
  has_many :projects, dependent: :destroy
  has_many :education_histories, dependent: :destroy
  has_many :work_histories, dependent: :destroy
  has_one :user_profile, dependent: :destroy
end
