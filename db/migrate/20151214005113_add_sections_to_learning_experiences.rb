class AddSectionsToLearningExperiences < ActiveRecord::Migration
  def change
    add_column :learning_experiences, :section, :string
  end
end
