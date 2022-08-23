class JobApplication < ApplicationRecord
  belongs_to :user
  belongs_to :job

  validates_uniqueness_of :user_id, scope: %i[job_id]
end
