# frozen_string_literal: true

require 'factory_bot'

FEATURES_ARRAY = ['business strategy', 'app development', 'app design', 'mobile app', 'CEO marketing',
                  'UI & UX design'].freeze
PROJECTS_ARRAY = [
  { title: 'The services provide for design', filename: 'portfolio-01.jpg' },
  { title: 'Mobile app landing design & app maintain', filename: 'portfolio-02.jpg' },
  { title: 'Logo design creativity & application', filename: 'portfolio-03.jpg' }
].freeze
BLOGS_ARRAY = [
  { title: 'The services provide for design', filename: 'blog-01.jpg' },
  { title: 'Mobile app landing design & app maintain', filename: 'blog-02.jpg' },
  { title: 'T-shirt design is the part of design', filename: 'blog-03.jpg' }
].freeze

class User < ApplicationRecord
  has_secure_password
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }
  validates :password, confirmation: true
  validates :first_name, :last_name, presence: true

  has_many :user_contacts
  has_many :users_skills, dependent: :destroy
  has_many :skills, through: :users_skills
  has_many :features, dependent: :destroy
  has_many :blogs, dependent: :destroy
  has_many :projects, dependent: :destroy
  has_many :education_histories, dependent: :destroy
  has_many :work_histories, dependent: :destroy
  has_one :user_profile, dependent: :destroy
  has_many :jobs, dependent: :destroy
  has_many :job_applications
  has_many :applied_jobs, through: :job_applications, source: :job
  has_many :sent_messages, class_name: 'Message', foreign_key: 'sender_id', dependent: :destroy
  has_many :received_messages, class_name: 'Message', foreign_key: 'recipient_id'
  accepts_nested_attributes_for :user_profile, :features, :users_skills, :projects, :blogs, :education_histories,
                                :work_histories, reject_if: :all_blank, allow_destroy: true

  after_create :default_user_profile

  def message_threads
    Message.where('(sender_id = ?  OR recipient_id = ? ) and parent_message_id is null', self.id, self.id)
  end


  private

  def default_user_profile
    FactoryBot.create(:user_profile, user: self)
  end
end
