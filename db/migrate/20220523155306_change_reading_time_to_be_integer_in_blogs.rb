class ChangeReadingTimeToBeIntegerInBlogs < ActiveRecord::Migration[7.0]
  def change
    remove_column :blogs, :reading_time, :time
    add_column :blogs, :reading_time, :integer, null: false
  end
end
