class CreateCohortEpics < ActiveRecord::Migration
  def change
    create_table :cohort_epics do |t|
      t.belongs_to :epic, null: false
      t.belongs_to :cohort, null: false
      t.timestamps null: false
    end
  end
end
