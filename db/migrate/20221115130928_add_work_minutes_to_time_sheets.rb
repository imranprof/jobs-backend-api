class AddWorkMinutesToTimeSheets < ActiveRecord::Migration[7.0]
  def change
    add_column :time_sheets, :work_minutes, :integer
  end
end
