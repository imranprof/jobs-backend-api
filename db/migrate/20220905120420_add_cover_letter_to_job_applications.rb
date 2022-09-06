class AddCoverLetterToJobApplications < ActiveRecord::Migration[7.0]
  def change
    add_column :job_applications, :cover_letter, :text, null: false
  end
end
