class CreateSocialLinks < ActiveRecord::Migration[7.0]
  def change
    create_table :social_links do |t|
      t.string :facebook_url
      t.string :github_url
      t.string :linkedin_url
      t.timestamps
      t.belongs_to  :user_profile, foreign_key: true, null: false
    end
  end
end
