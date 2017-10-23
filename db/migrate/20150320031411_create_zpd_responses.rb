class CreateZpdResponses < ActiveRecord::Migration
  def change
    create_table :zpd_responses do |t|
      t.integer :user_id, null: false
      t.integer :response, null: false
      t.date :date, null: false

      t.timestamps
    end
  end
end
