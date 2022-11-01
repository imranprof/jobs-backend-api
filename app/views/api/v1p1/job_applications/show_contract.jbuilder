# frozen_string_literal: true

json.contract_details do
  json.id @job_contract.id
  json.contract_title @job_contract.job.title
  json.job_type @job_contract.pay_type
  json.contract_budget @job_contract.hire_rate[0]
  if @is_employee
    json.name "#{@job_contract.job.employer.first_name} #{@job_contract.job.employer.last_name}"
    json.avatar request.base_url.concat(url_for(@job_contract.job.employer.user_profile.avatar))
    json.feedback @job_contract.employer_feedback
    json.rating @job_contract.employer_rating
  else
    json.name "#{@job_contract.user.first_name} #{@job_contract.user.last_name}"
    json.avatar request.base_url.concat(url_for(@job_contract.user.user_profile.avatar))
    json.feedback @job_contract.employee_feedback
    json.rating @job_contract.employee_rating
  end
end
