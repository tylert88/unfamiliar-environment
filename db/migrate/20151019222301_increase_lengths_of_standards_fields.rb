class IncreaseLengthsOfStandardsFields < ActiveRecord::Migration
  def up
    change_column :curriculum_notifications, :resource_name, :string, limit: 1000, null: false
  end
end
