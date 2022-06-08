class AddDesignationAndContactInfoColumnToUserProfiles < ActiveRecord::Migration[7.0]
  def change
    add_column :user_profiles, :designation, :string, null: false, default: ""
    add_column :user_profiles, :contact_info, :text, null: false, default: ""
  end
end
