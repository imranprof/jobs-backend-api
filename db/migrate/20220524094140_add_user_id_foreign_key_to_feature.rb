class AddUserIdForeignKeyToFeature < ActiveRecord::Migration[7.0]
  def change
    add_reference :features, :user, index: true, null: false
    add_foreign_key :features, :users
  end
end
