# frozen_string_literal: true

class Job < ApplicationRecord
  enum status: { draft: 0, published: 1, closed: 2, canceled: 3 }

  belongs_to :employer, foreign_key: :user_id, class_name: 'User'
  has_many :job_applications, dependent: :destroy
  has_many :applicants, through: :job_applications, source: :user
end
