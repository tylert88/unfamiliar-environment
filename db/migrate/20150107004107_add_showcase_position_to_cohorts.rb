class AddShowcasePositionToCohorts < ActiveRecord::Migration
  def change
    add_column :cohorts, :showcase_position, :integer, null: false, default: 0
  end
end
