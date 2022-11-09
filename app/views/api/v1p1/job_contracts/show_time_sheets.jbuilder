# frozen_string_literal: true

json.time_sheets @time_sheets do |task|
  json.id task.id
  json.start_date(task.start_date.strftime('%d-%m-%Y')) if task.start_date?
  json.end_date(task.end_date.strftime('%d-%m-%Y')) if task.end_date?
  json.work_description task.work_description
  json.work_hours task.work_hours
end
