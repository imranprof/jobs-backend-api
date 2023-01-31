class AddHireRateAndPayTypeToJobApplications < ActiveRecord::Migration[7.0]
  def change
    add_column :job_applications, :pay_type, :string
    add_column :job_applications, :hire_rate, :integer, array: true, default: []
  end
end
