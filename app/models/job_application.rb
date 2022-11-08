class JobApplication < ApplicationRecord
  enum contract_status: { Pending: 0, InProgress: 1, Closed: 2 }

  scope :by_contract_status, ->(status = 0) { where('contract_status = ?', status) }

  belongs_to :user
  belongs_to :job
  has_many :time_sheets, dependent: :destroy

  after_create :send_notification_to_employer

  validates_uniqueness_of :user_id, scope: %i[job_id]
  validates :cover_letter, presence: true

  def send_notification_to_employer
    JobApplicationMailer.employer_notification_email(self).deliver_now
  end

  def self.find_job_contract(id, current_user)
    @is_employee = current_user.role == 'employee'
    @contract = JobApplication.find_by(id: id)

    @recipient = if @is_employee
                   @contract.job.employer
                 else
                   @contract.user
                 end
    @job_contract = if @is_employee
                      current_user.job_applications.find_by(id: id)
                    else
                      current_user.jobs.find_by(id: @contract.job_id)&.job_applications&.find_by(id: @contract.id)
                    end
    [@job_contract, @recipient]
  end

end
