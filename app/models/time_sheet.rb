# frozen_string_literal: true

class TimeSheet < ApplicationRecord
  enum status: { pending: 0, requested: 1, approved: 2, rejected: 3 }

  scope :by_status, ->(status = 0) { where('status = ?', status) }

  belongs_to :contract, class_name: 'JobApplication', foreign_key: 'job_application_id'

end
