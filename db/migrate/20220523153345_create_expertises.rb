class CreateExpertises < ActiveRecord::Migration[7.0]
  def change
    create_table :expertises do |t|
      t.string :title, null: false
      t.belongs_to :user_profile, foreign_key: true, null: false
      t.timestamps
    end
  end
end
