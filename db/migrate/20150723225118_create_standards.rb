class CreateStandards < ActiveRecord::Migration
  def change
    create_table :standards do |t|
      t.integer :curriculum_unit_id, null: false
      t.string :name, null: false

      t.timestamps
    end
  end
end
