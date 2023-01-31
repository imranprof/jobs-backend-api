# frozen_string_literal: true

json.time_sheet do
  json.id @time_sheet.id
  json.start_date(@time_sheet.start_date&.strftime('%d-%m-%Y'))
  json.end_date(@time_sheet.end_date&.strftime('%d-%m-%Y'))
  json.work_description @time_sheet.work_description
  json.work_hours @time_sheet.work_hours
  json.work_minutes @time_sheet.work_minutes
end
