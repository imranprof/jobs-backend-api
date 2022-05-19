# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }
  validates :password, confirmation: true

  has_one :user_profile

  has_many :user_contacts
  has_many :users_skills
  has_many :blogs
  has_many :features
  has_many :projects
  has_many :education_histories
  has_many :work_histories
end
