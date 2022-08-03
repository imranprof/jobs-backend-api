class Categorization < ApplicationRecord
  belongs_to :category
  belongs_to :categorizable, polymorphic: true

  validates_uniqueness_of :category_id, scope: %i[categorizable_id categorizable_type]
end
