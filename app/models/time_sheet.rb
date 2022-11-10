# frozen_string_literal: true

class TimeSheet < ApplicationRecord
  belongs_to :contract, class_name: 'JobApplication', foreign_key: 'job_application_id'
  belongs_to :user

end
