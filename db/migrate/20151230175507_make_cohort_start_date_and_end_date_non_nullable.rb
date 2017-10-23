class MakeCohortStartDateAndEndDateNonNullable < ActiveRecord::Migration
  def up
    change_column :cohorts, :start_date, :date, null: false
    change_column :cohorts, :end_date, :date, null: false
  end

  def down
    change_column :cohorts, :start_date, :date, null: true
    change_column :cohorts, :end_date, :date, null: true
  end
end
