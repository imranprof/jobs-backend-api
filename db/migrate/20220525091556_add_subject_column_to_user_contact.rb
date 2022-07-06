class AddSubjectColumnToUserContact < ActiveRecord::Migration[7.0]
  def change
    add_column :user_contacts, :subject, :string, null: true
  end
end
