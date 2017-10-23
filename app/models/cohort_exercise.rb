class CohortExercise < ActiveRecord::Base
  belongs_to :exercise
  belongs_to :cohort
  before_destroy :check_for_submissions?

  validates :exercise, :cohort, :presence => true
  delegate :name, :to => :exercise

  def submissions
    exercise.submissions.for_cohort(cohort)
  end

  def students_missing_submission
    User.for_cohort(cohort) - submissions.map(&:user)
  end

  def check_for_submissions?
    !submissions.present?
  end

end
