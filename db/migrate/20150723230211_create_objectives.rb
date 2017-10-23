class CreateObjectives < ActiveRecord::Migration
  def change
    create_table :objectives do |t|
      t.string :name, null: false
      t.integer :standard_id, null: false

      t.timestamps
    end
  end
end
