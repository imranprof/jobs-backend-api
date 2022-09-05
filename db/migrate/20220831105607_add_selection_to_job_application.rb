class AddSelectionToJobApplication < ActiveRecord::Migration[7.0]
  def change
    add_column :job_applications, :selection, :boolean, null: true
  end
end
