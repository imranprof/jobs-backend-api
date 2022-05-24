class AddExpertisesToUserProfiles < ActiveRecord::Migration[7.0]
  def change
    add_column :user_profiles, :expertises, :string, array: true, default: []
  end
end
