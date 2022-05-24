class RemoveUserIdForeignKeyFromProjectCategories < ActiveRecord::Migration[7.0]
  def change
    remove_column :project_categories, :user_id
  end
end
