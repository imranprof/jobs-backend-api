class AddEmployeeAndEmployerFeedbackAndRatingToJobApplication < ActiveRecord::Migration[7.0]
  def change
    add_column :job_applications, :employee_feedback, :string
    add_column :job_applications, :employer_feedback, :string
    add_column :job_applications, :employee_rating, :decimal, precision: 3, scale: 2
    add_column :job_applications, :employer_rating, :decimal, precision: 3, scale: 2
  end
end
