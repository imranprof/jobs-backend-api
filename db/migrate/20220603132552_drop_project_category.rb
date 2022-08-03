class DropProjectCategory < ActiveRecord::Migration[7.0]
  def change
    drop_table :project_categories
  end
end
