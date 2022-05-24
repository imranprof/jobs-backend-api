class SetPhoneColumnNullableInUsers < ActiveRecord::Migration[7.0]
  def change
    change_column :users, :phone, :string, null: true
  end
end
