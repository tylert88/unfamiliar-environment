class CreatePerformances < ActiveRecord::Migration
  def change
    create_table :performances do |t|
      t.integer :user_id, null: false
      t.index :user_id
      t.integer :objective_id, null: false
      t.index :objective_id
      t.integer :updator_id, null: false
      t.integer :score
      t.json :history
      t.json :comments
      t.index [:user_id, :objective_id], unique: true
      t.timestamps null: false
    end
  end
end
