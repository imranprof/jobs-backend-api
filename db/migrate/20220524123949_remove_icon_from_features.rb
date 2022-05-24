class RemoveIconFromFeatures < ActiveRecord::Migration[7.0]
  def change
    remove_column :features, :icon
  end
end
