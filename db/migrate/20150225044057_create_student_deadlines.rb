class CreateStudentDeadlines < ActiveRecord::Migration
  def change
    create_table :student_deadlines do |t|
      t.integer :user_id, null: false
      t.integer :deadline_id, null: false
      t.boolean :complete, null: false, default: false
    end
  end
end
