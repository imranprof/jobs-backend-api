class WorkHistory < ApplicationRecord
  belongs_to :user

  validates :title, :employment_type, :company_name, :description, :start_date, :end_date, presence: true
  validates_inclusion_of :currently_employed, :visibility, in: [true, false]
end
