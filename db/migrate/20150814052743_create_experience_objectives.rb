class CreateExperienceObjectives < ActiveRecord::Migration
  def change
    create_table :experience_objectives do |t|
      t.belongs_to :learning_experience, null: false, index: true
      t.belongs_to :objective, null: false, index: true
      t.timestamps null: false
    end
  end
end
