class AddFieldsToActionPlanEntries < ActiveRecord::Migration
  def change
    change_table :action_plan_entries do |t|
      t.date :started_on
      t.date :due_on
      t.date :completed_on
      t.belongs_to :learning_experience, index: true
      t.integer :status, null: false, default: 0
    end
  end
end
