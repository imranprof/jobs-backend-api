json.job_offers @job_contracts do |contract|
  json.id contract.id
  json.related_job_title contract.job.title
  json.contract_budget contract.hire_rate[0]
end
