class AddPhoneColumnToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :phone, :string, null: true
  end
end
