class DropGraduationRequirementsTable < ActiveRecord::Migration
  def change
    drop_table :graduation_requirements
  end
end
