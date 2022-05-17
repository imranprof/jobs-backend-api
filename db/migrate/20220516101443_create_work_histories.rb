class CreateWorkHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :work_histories do |t|
      t.string     :title, null: false
      t.integer    :employment_type, null: false
      t.string     :company_name, null: false
      t.text       :description, limit: 1000, null: false
      t.datetime   :start_date, null: false
      t.datetime   :end_date, null: false
      t.boolean    :currently_employed, null: false
      t.boolean    :visibility, null: false
      t.belongs_to :user, foreign_key: true, null: false
      t.timestamps
    end
  end
end
