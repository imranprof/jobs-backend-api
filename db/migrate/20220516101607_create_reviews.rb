class CreateReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :reviews do |t|
      t.string  :reviewer_name, null: false
      t.string  :reviewer_designation, null: false
      t.text    :description, limit: 500, null: false
      t.string  :reviewer_profile_url, null: false
      t.boolean :visibility, null: false
      t.decimal :rating, null: false
      t.timestamps
    end
  end
end
