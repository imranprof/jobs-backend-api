class AddPayTypeToJobs < ActiveRecord::Migration[7.0]
  def change
    add_column :jobs, :pay_type, :string
  end
end
