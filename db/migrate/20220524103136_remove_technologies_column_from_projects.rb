class RemoveTechnologiesColumnFromProjects < ActiveRecord::Migration[7.0]
  def change
    remove_column :projects, :technologies
  end
end
