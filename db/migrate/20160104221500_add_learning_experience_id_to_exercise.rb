class AddLearningExperienceIdToExercise < ActiveRecord::Migration
  def change
    add_column :exercises, :learning_experience_id, :integer
  end
end
