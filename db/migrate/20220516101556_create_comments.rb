class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.text :body, limit: 500, null: false
      t.timestamps
    end
  end
end
