class CreateAssignedLearningExperiences < ActiveRecord::Migration
  def change
    create_table :assigned_learning_experiences do |t|
      t.belongs_to :learning_experience, null: false
      t.belongs_to :cohort, null: false
      t.index [:learning_experience_id, :cohort_id], unique: true, name: :idx_assigned_experiences
      t.timestamps
    end

    execute <<-SQL
      ALTER TABLE assigned_learning_experiences
        ADD CONSTRAINT fk_assigned_experience_id
        FOREIGN KEY (learning_experience_id) REFERENCES learning_experiences (id)
        ON DELETE CASCADE;
    SQL

    execute <<-SQL
      ALTER TABLE assigned_learning_experiences
        ADD CONSTRAINT fk_assigned_cohort_id
        FOREIGN KEY (cohort_id) REFERENCES cohorts (id)
        ON DELETE CASCADE;
    SQL

  end
end
