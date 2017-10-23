class AssociateExercisesWithSuccessCriteria < ActiveRecord::Migration
  def change
    create_table :exercise_objectives do |eo|
      eo.timestamps null: false
      eo.integer :exercise_id
      eo.integer :objective_id
    end
    add_index :exercise_objectives, :objective_id
    remove_column :exercises, :learning_experience_id, :integer
  end
end
