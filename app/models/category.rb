class Category < ApplicationRecord
  has_many :categorizations, dependent: :destroy
  has_many :projects,  through: :categorizations, source: :categorizable, source_type: 'Project'
  has_many :blogs, through: :categorizations, source: :categorizable, source_type: 'Blog'
end
