class AddInstructorNotesToLearningExperiences < ActiveRecord::Migration
  def change
    add_column :learning_experiences, :instructor_notes, :text
    add_column :learning_experiences, :mainline, :boolean, null: false, default: true
  end
end
