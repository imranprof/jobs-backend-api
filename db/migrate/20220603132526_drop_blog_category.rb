class DropBlogCategory < ActiveRecord::Migration[7.0]
  def change
    drop_table :blog_categories
  end
end
