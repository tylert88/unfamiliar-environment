class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.string :name, null: false
      t.datetime :due_date, null: false
      t.string :url
      t.integer :cohort_id, null: false
    end
  end
end
