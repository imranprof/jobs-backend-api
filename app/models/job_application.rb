class JobApplication < ApplicationRecord
  enum contract_status: { Pending: 0, InProgress: 1, Closed: 2 }

  scope :by_contract_status, ->(status = 0) { where('contract_status = ?', status) }

  belongs_to :user
  belongs_to :job

  after_create :send_notification_to_employer

  validates_uniqueness_of :user_id, scope: %i[job_id]
  validates :cover_letter, presence: true

  def send_notification_to_employer
    JobApplicationMailer.employer_notification_email(self).deliver_now
  end
end
