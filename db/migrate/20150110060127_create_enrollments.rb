class CreateEnrollments < ActiveRecord::Migration
  def change
    create_table :enrollments do |t|
      t.belongs_to :user, null: false
      t.belongs_to :cohort, null: false
      t.integer :role, null: false
      t.integer :status, null: false
      t.index [:user_id, :cohort_id, :role], unique: true
      t.timestamps null: false
    end
  end
end
