# frozen_string_literal: true

json.time_sheets @time_sheets do |work|
  json.id work.id
  json.start_date work.start_date
  json.end_date work.end_date
  json.work_description work.work_description
  json.work_hours work.work_hours
end
