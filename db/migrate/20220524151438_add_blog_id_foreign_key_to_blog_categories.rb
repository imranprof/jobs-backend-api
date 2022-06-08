class AddBlogIdForeignKeyToBlogCategories < ActiveRecord::Migration[7.0]
  def change
    add_reference :blog_categories, :blog, foreign_key: true
  end
end
