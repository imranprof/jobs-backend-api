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
  accepts_nested_attributes_for :user_profile, :features, :users_skills, :projects, :blogs, :education_histories,
                                :work_histories, reject_if: :all_blank, allow_destroy: true

  after_create :default_user_profile

  private

  def default_user_profile
    FactoryBot.create(:user_profile, user: self)
    Skill.all.each do |skill|
      FactoryBot.create(:users_skill, user: self, skill: skill, rating: 90)
    end
    FEATURES_ARRAY.each do |feature_title|
      FactoryBot.create(:feature, user: self, title: feature_title)
    end
    PROJECTS_ARRAY.each do |project|
      FactoryBot.create(:project, user: self, title: project[:title], filename: project[:filename])
    end
    FactoryBot.create(:education_history, user: self, institution: 'University of A', degree: 'diploma', grade: 'B',
                                          start_date: DateTime.iso8601('2016-01-01', Date::ENGLAND),
                                          end_date: DateTime.iso8601('2018-01-01', Date::ENGLAND))
    FactoryBot.create(:education_history, user: self, institution: 'University of B', degree: 'diploma', grade: 'B',
                                          start_date: DateTime.iso8601('2018-01-01', Date::ENGLAND),
                                          end_date: DateTime.iso8601('2022-01-01', Date::ENGLAND))
    FactoryBot.create(:work_history, user: self, title: 'The Personal Portfolio Mystery', employment_type: 0,
                                     company_name: 'Company A', start_date: DateTime.iso8601('2018-01-01', Date::ENGLAND),
                                     end_date: DateTime.iso8601('2019-01-01', Date::ENGLAND), currently_employed: true,
                                     visibility: true)
    FactoryBot.create(:work_history, user: self, title: 'Tips For Personal Portfolio', employment_type: 0,
                                     company_name: 'Company B', start_date: DateTime.iso8601('2018-01-01', Date::ENGLAND),
                                     end_date: DateTime.iso8601('2019-01-01', Date::ENGLAND), currently_employed: true,
                                     visibility: true)
    BLOGS_ARRAY.each do |blog|
      FactoryBot.create(:blog, user: self, title: blog[:title], filename: blog[:filename])
    end
  end
end
