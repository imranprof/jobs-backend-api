class CreateEducationHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :education_histories do |t|
      t.string :institution, null: false
      t.string :degree, null: false
      t.string :grade, null: false
      t.text :description, limit: 500, null: false
      t.datetime :start_date, null: false
      t.datetime :end_date, null: false
      t.boolean :currently_enrolled, null: false
      t.boolean :visibility, null: false
      t.belongs_to :user, foreign_key: true, null: false
      t.timestamps
    end
  end
end
