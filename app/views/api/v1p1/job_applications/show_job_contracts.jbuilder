# frozen_string_literal: true

json.job_contracts @job_contracts do |contract|
  json.id contract.id
  json.contract_title contract.job.title
  json.contract_budget contract.hire_rate[0]
  json.job_type contract.pay_type
  json.contract_status contract.contract_status == 'closed'
  if @is_employee
    json.name "#{contract.job.employer.first_name} #{contract.job.employer.last_name}"
    json.self_rating contract.employee_rating
    json.get_rating contract.employer_rating
  else
    json.name "#{contract.user.first_name} #{contract.user.last_name}"
    json.self_rating contract.employer_rating
    json.get_rating contract.employee_rating
  end
end
