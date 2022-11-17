class CreateTimeSheets < ActiveRecord::Migration[7.0]
  def change
    create_table :time_sheets do |t|
      t.date :start_date
      t.date :end_date
      t.text :work_description
      t.integer :work_hours
      t.belongs_to :job_application, null: false, foreign_key: true
      t.timestamps
    end
  end
end
