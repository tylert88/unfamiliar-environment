class MakeLearningExperiencesSuggestedDaysDecimal < ActiveRecord::Migration
  def change
    change_column :learning_experiences, :suggested_days, :decimal
  end
end
