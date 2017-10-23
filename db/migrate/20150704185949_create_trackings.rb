class CreateTrackings < ActiveRecord::Migration
  def change
    create_table :trackings do |t|
      t.integer :cohort_id, null: false
      t.string :name
      t.json :results
      t.timestamps null: false
    end
  end
end
