class DropSubmittedExercises < ActiveRecord::Migration
  def change
    drop_table :submitted_exercises
  end
end
