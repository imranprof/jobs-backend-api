class AddSlugToUserProfiles < ActiveRecord::Migration[7.0]
  def change
    add_column :user_profiles, :slug, :string
    add_index :user_profiles, :slug, unique: true
  end
end
