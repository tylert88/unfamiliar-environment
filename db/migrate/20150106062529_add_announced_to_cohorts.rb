class AddAnnouncedToCohorts < ActiveRecord::Migration
  def change
    add_column :cohorts, :announced, :boolean, default: false, null: false
    execute 'update cohorts set announced = true'
  end
end
