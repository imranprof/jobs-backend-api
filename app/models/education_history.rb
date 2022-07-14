class EducationHistory < ApplicationRecord
  belongs_to :user

  validates :institution, :degree, :grade, :description, :start_date, :end_date, presence: true
  validates_inclusion_of :currently_enrolled, :visibility, in: [true, false]
end
