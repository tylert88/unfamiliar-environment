class AddSuggestedTimeToLearningExperiences < ActiveRecord::Migration
  def change
    add_column :learning_experiences, :suggested_days, :integer
  end
end
