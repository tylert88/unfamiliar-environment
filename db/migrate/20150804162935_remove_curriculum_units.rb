class RemoveCurriculumUnits < ActiveRecord::Migration
  def change
    drop_table :curriculum_units
    remove_column :standards, :curriculum_unit_id
    add_column :standards, :curriculum_id, :integer
    add_index :standards, :curriculum_id
  end
end
