class AddStatusToPerformances < ActiveRecord::Migration
  def change
    add_column :performances, :status, :integer, null: false, default: 0
  end
end
