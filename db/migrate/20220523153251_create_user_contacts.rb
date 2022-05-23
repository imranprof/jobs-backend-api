class CreateUserContacts < ActiveRecord::Migration[7.0]
  def change
    create_table :user_contacts do |t|
      t.string :name, null: false
      t.string :phone_number, null: false
      t.string :email, null: false
      t.text :message, limit: 1000, null: false
      t.integer :user_id, null: false
      t.integer :messenger_id
      t.timestamps
    end
    add_foreign_key :user_contacts, :users, column: :user_id
    add_foreign_key :user_contacts, :users, column: :messenger_id
  end
end
