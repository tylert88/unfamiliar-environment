class DropUserLearningExperiences < ActiveRecord::Migration
  def change
    drop_table :user_learning_experiences
  end
end
