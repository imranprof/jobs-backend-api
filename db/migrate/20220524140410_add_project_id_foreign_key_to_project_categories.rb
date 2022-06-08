class AddProjectIdForeignKeyToProjectCategories < ActiveRecord::Migration[7.0]
  def change
    add_reference :project_categories, :project, foreign_key: true
  end
end
