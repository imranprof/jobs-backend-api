class AddCustomSkillToSkills < ActiveRecord::Migration[7.0]
  def change
    add_column :skills, :custom_skill, :boolean, null: false, default: false
  end
end
