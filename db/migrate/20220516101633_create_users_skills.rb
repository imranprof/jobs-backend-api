class CreateUsersSkills < ActiveRecord::Migration[7.0]
  def change
    create_table :users_skills do |t|
      t.integer :rating
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :skill, null: false, foreign_key: true
      t.timestamps
    end
  end
end
