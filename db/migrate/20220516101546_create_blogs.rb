class CreateBlogs < ActiveRecord::Migration[7.0]
  def change
    create_table :blogs do |t|
      t.string     :title, null: false
      t.text       :body, limit: 5000, null: false
      t.time       :reading_time, null: false
      t.belongs_to :user, null:false, foreign_key: true
      t.timestamps
    end
  end
end
