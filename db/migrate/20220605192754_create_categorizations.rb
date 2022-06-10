class CreateCategorizations < ActiveRecord::Migration[7.0]
  def change
    create_table :categorizations do |t|
      t.references :category, foreign_key: true, null: false
      t.references :categorizable, polymorphic: true, null: false
      t.timestamps
    end
  end
end
