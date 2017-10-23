class CreateStudentChallenges < ActiveRecord::Migration
  def change
    create_table :student_challenges do |t|
      t.integer :challenge_id, null: false
      t.string  :file, null: false
      t.integer :user_id, null: false
      t.integer :passed, null: false, default: 0
      t.integer :failed, null: false, default: 0
      t.integer :submission_count, null: false, default: 1
      t.boolean :complete, null: false, default: false


      t.timestamps null: false
    end
  end
end
