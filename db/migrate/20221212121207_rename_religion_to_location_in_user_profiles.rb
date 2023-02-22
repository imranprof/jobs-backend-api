class RenameReligionToLocationInUserProfiles < ActiveRecord::Migration[7.0]
  def change
    rename_column :user_profiles, :religion, :location
    change_column :user_profiles, :location, :string
  end
end
