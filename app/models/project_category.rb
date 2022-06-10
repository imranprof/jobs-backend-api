class ProjectCategory < ApplicationRecord
  belongs_to :project
  belongs_to :category

  def title
    category.title
  end
end
