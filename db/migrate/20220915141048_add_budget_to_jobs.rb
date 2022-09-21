class AddBudgetToJobs < ActiveRecord::Migration[7.0]
  def change
    add_column :jobs, :budget, :integer, array: true, default: []
  end
end
