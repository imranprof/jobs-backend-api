class CreateUserProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :user_profiles do |t|
      t.text        :headline, limit: 500, null: false
      t.string      :title, null: false
      t.text        :bio, limit: 5000, null: false
      t.string      :identity_number, null: false
      t.integer     :gender, null: false
      t.integer     :religion, null: false
      t.blob        :avatar, null: false
      t.belongs_to  :user, foreign_key: true, null: false
      t.timestamps
    end
  end
end
