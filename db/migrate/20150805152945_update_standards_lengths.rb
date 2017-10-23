class UpdateStandardsLengths < ActiveRecord::Migration
  def change
    change_column :standards, :name, :string, limit: 1000
    change_column :objectives, :name, :string, limit: 1000
  end
end
