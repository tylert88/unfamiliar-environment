class RemovePerformanceStatus < ActiveRecord::Migration
  def change
    remove_column :performances, :status
  end
end
