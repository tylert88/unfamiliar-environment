class RemoveExcessPropertiesFromCurriculumUnits < ActiveRecord::Migration
  def change
    change_column_null :curriculum_units, :position, true
    change_column_null :curriculum_units, :assessment, true
    change_column_null :curriculum_units, :objectives, true
  end
end
