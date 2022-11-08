class JobApplication < ApplicationRecord
  belongs_to :user
  belongs_to :job
  has_many :time_sheets, dependent: :destroy

  after_create :send_notification_to_employer

  validates_uniqueness_of :user_id, scope: %i[job_id]
  validates :cover_letter, presence: true

  def send_notification_to_employer
    JobApplicationMailer.employer_notification_email(self).deliver_now
  end
end
