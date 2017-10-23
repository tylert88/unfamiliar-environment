class CreateSubmittedExercises < ActiveRecord::Migration
  def change
    create_table :submitted_exercises do |t|
      t.string :file, null: false
      t.integer :user_id, null: false
      t.integer :passed, null: false, default: 0
      t.integer :failed, null: false, default: 0
      t.integer :submission_count, null: false, default: 1
      t.boolean :complete, null: false, default: false

      t.timestamps
    end
  end
end
