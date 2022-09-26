class AddHasReadToMessages < ActiveRecord::Migration[7.0]
  def change
    add_column :messages, :has_read, :boolean, default: false
  end
end
