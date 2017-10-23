class AddPositionToStandardsAndObjectives < ActiveRecord::Migration
  class MigrationStandard < ActiveRecord::Base
    self.table_name = :standards
  end

  class MigrationObjective < ActiveRecord::Base
    self.table_name = :objectives
  end

  def change
    MigrationStandard.reset_column_information
    MigrationObjective.reset_column_information

    add_column :standards, :position, :integer
    add_column :objectives, :position, :integer

    MigrationStandard.all.group_by(&:curriculum_id).each do |_, standards|
      standards.each_with_index do |standard, i|
        standard.update(position: i)
      end
    end

    MigrationObjective.all.group_by(&:standard_id).each do |_, objectives|
      objectives.each_with_index do |objective, i|
        objective.update(position: i)
      end
    end

    change_column :standards, :position, :integer, null: false
    change_column :objectives, :position, :integer, null: false
  end
end
