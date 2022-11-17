class ChangeWorkHoursType < ActiveRecord::Migration[7.0]
  def change
    change_column(:time_sheets, :work_hours, :decimal, precision: 3, scale: 2)
  end
end
