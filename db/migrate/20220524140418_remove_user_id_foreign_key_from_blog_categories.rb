class RemoveUserIdForeignKeyFromBlogCategories < ActiveRecord::Migration[7.0]
  def change
    remove_column :blog_categories, :user_id
  end
end
