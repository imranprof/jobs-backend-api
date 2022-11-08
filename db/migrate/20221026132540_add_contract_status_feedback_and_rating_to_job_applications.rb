class AddContractStatusFeedbackAndRatingToJobApplications < ActiveRecord::Migration[7.0]
  def change
    add_column :job_applications, :contract_status, :integer, default: 0
    add_column :job_applications, :feedback, :string
    add_column :job_applications, :rating, :decimal, precision: 4, scale: 3
  end
end
