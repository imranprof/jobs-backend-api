class AddContactEmailColumnToUserProfiles < ActiveRecord::Migration[7.0]
  def change
    add_column :user_profiles, :contact_email, :string
  end
end
