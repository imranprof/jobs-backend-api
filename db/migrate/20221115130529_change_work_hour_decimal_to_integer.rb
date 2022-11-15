class ChangeWorkHourDecimalToInteger < ActiveRecord::Migration[7.0]
  def change
    change_column(:time_sheets, :work_hours, :integer)
  end
end
