# frozen_string_literal: true

class Job < ApplicationRecord
  enum status: { Draft: 0, Published: 1, Closed: 2, Canceled: 3 }

  belongs_to :employer, foreign_key: :user_id, class_name: 'User'
  has_many :job_applications, dependent: :destroy
  has_many :applicants, through: :job_applications, source: :user

  PAGINATION_LIMIT = 8

  def self.find_best_jobs_by_skills(current_user)
    skills = current_user.skills.map{|skill| "%#{skill.title.downcase}%"}
    self.where("lower(array_to_string(skills, '||')) LIKE any (array[?]) ", skills).limit(10)
  end

  def self.find_recent_jobs_by_skills(current_user, page_number)
    skills = current_user.skills.map{|skill| "%#{skill.title.downcase}%"}
    self.where("lower(array_to_string(skills, '||')) LIKE any (array[?]) ", skills)
        .order(created_at: :desc)
        .limit(PAGINATION_LIMIT)
        .offset((page_number.to_i || 0) * PAGINATION_LIMIT)
  end
end
