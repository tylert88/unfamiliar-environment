class AssignmentSubmission < ActiveRecord::Base
  belongs_to :user
  belongs_to :assignment
  has_many :assignment_submission_notes

  def self.approaching_assignments_for(user_id)
    AssignmentSubmission.where(user_id: user_id, complete: false).joins(:assignment).where(assignments: {due_date: ((Date.current-180).to_time)..(Date.current+3).to_time})
  end

  def self.seed_for_assignment(assignment, cohort)
    users = User.for_cohort(cohort)
    users.map { |user| AssignmentSubmission.create!(assignment_id: assignment.id, user_id: user.id)}
  end
end
