class Category < ApplicationRecord
  has_many :blog_categories, dependent: :destroy
  has_many :project_categories, dependent: :destroy
end
