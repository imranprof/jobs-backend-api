class DropTableExpertises < ActiveRecord::Migration[7.0]
  def change
    drop_table :expertises
  end
end
