class AddLabelToCohort < ActiveRecord::Migration
  def change
    add_column :cohorts, :label, :string
  end
end
