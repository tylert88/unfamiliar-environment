class CreateAssignmentSubmissionNotes < ActiveRecord::Migration
  def change
    create_table :assignment_submission_notes do |t|
      t.integer :assignment_submission_id, null: false
      t.text :content

      t.timestamps null: false
    end
  end
end
