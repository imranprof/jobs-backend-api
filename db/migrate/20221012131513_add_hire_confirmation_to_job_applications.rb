class AddHireConfirmationToJobApplications < ActiveRecord::Migration[7.0]
  def change
    add_column :job_applications, :hire_confirmation, :boolean, null: true
  end
end
