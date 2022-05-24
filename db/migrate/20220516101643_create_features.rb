class CreateFeatures < ActiveRecord::Migration[7.0]
  def change
    create_table :features do |t|
      t.string :title, null: false
      t.text :description, limit: 1000, null: false
      t.blob :icon, null: false
      t.timestamps
    end
  end
end
