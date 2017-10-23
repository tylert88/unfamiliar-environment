class AddTimeSpentToAssignmentSubmission < ActiveRecord::Migration
  def change
    add_column :assignment_submissions, :time_spent, :integer
  end
end
