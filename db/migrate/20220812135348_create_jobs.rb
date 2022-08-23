class CreateJobs < ActiveRecord::Migration[7.0]
  def change
    create_table :jobs do |t|
      t.string     :title, null: false
      t.text       :description
      t.string     :location
      t.string     :skills, array: true, default: []
      t.belongs_to :user, foreign_key: true, null: false
      t.timestamps
    end
  end
end
