class AddModifyRoleColumnToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :modify_role, :boolean, default: false

  end
end
