class AddCurriculumIdToExercises < ActiveRecord::Migration

  class MigrationCurriculum < ActiveRecord::Base
    self.table_name = :curriculums
  end

  class MigrationExercise < ActiveRecord::Base
    self.table_name = :exercises
  end

  def change
    add_column :exercises, :curriculum_id, :integer

    MigrationExercise.reset_column_information

    if full_stack = MigrationCurriculum.find_by(name: 'Full Stack')
      MigrationExercise.update_all(curriculum_id: full_stack.id)
    elsif other = MigrationCurriculum.first
      MigrationExercise.update_all(curriculum_id: other.id)
    end

    change_column :exercises, :curriculum_id, :integer, null: false

    execute <<-SQL
      ALTER TABLE exercises
        ADD CONSTRAINT fk_exercises_curriculum_id
        FOREIGN KEY (curriculum_id) REFERENCES curriculums (id)
        ON DELETE RESTRICT;
    SQL

  end
end
