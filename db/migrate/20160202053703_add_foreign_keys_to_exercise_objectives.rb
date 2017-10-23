class AddForeignKeysToExerciseObjectives < ActiveRecord::Migration
  def change
    execute <<-SQL
      ALTER TABLE exercise_objectives
        ADD CONSTRAINT fk_exercise_objectives_objective_id
        FOREIGN KEY (objective_id) REFERENCES objectives (id)
        ON DELETE CASCADE;
    SQL

    execute <<-SQL
      ALTER TABLE exercise_objectives
        ADD CONSTRAINT fk_exercise_objectives_exercise_id
        FOREIGN KEY (exercise_id) REFERENCES exercises (id)
        ON DELETE CASCADE;
    SQL
  end
end
