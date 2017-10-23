class CreateAssignmentSubmissions < ActiveRecord::Migration
  def change
    create_table :assignment_submissions do |t|
      t.integer :user_id, null: false
      t.integer :assignment_id, null: false
      t.string :submission_url
      t.boolean :complete, default: false
      t.boolean :submitted, default: false

      t.timestamps null: false
    end
  end
end
