class CreateDeadlines < ActiveRecord::Migration
  def change
    create_table :deadlines do |t|
      t.string :name, null: false
      t.datetime :due_date, null: false
      t.string :url
      t.integer :cohort_id, null: false
    end
  end
end
