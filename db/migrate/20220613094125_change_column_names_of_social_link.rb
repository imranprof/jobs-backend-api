class ChangeColumnNamesOfSocialLink < ActiveRecord::Migration[7.0]
  def change
    rename_column :social_links, :facebook_url, :facebook
    rename_column :social_links, :github_url, :github
    rename_column :social_links, :linkedin_url, :linkedin
  end
end
