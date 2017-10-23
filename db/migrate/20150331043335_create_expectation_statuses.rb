class CreateExpectationStatuses < ActiveRecord::Migration
  def change
    create_table :expectation_statuses do |t|
      t.belongs_to :user, index: true, null: false
      t.belongs_to :cohort, index: true, null: false
      t.belongs_to :expectation, index: true, null: false
      t.belongs_to :author, index: true, null: false
      t.text :notes, null: false
      t.integer :status, null: false
      t.boolean :on_track, null: false, default: false
      t.timestamps null: false
    end
  end
end
