# frozen_string_literal: true

json.job_contracts @job_contracts do |contract|
  json.id contract.id
  json.contract_title contract.job.title
  json.contract_budget contract.hire_rate[0]
  json.job_type contract.pay_type
  if @is_employee
    json.name "#{contract.job.employer.first_name} #{contract.job.employer.last_name}"
  else
    json.name "#{contract.user.first_name} #{contract.user.last_name}"
  end
end
