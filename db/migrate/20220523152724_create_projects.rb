class CreateProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :projects do |t|
      t.string :title, null: false
      t.text :description, limit: 500, null: false
      t.text :technologies, limit: 500, null: false
      t.string :live_url, null: false
      t.string :source_url, null: false
      t.integer :react_count, null: false
      t.belongs_to :user, foreign_key: true, null: false
      t.timestamps
    end
  end
end
