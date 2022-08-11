class AddRoleAndCompanyNameToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :role, :string, null: false, default: 'employee'
    add_column :users, :company_name, :string
  end
end
