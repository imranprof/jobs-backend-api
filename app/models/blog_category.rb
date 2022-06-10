class BlogCategory < ApplicationRecord
  belongs_to :blog
  belongs_to :category

  def title
    category.title
  end
end
