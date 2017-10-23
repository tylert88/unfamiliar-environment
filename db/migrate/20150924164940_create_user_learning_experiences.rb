class CreateUserLearningExperiences < ActiveRecord::Migration
  def change
    create_table :user_learning_experiences do |t|
      t.integer :status
      t.belongs_to :user, index: true
      t.belongs_to :learning_experience, index: true

      t.timestamps
    end
  end
end
