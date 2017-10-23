class AssignmentSubmissionNote < ActiveRecord::Base
  validates :content, presence: true
  belongs_to :assignment_submission
end
