class ProjectCategory < ApplicationRecord
  belongs_to :project
  belongs_to :category

  def categories
    category
  end
end
