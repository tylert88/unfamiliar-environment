class AssignedLearningExperience < ActiveRecord::Base
  belongs_to :learning_experience
  belongs_to :cohort

  validates :learning_experience, presence: true
  validates :cohort, presence: true
  validates :learning_experience_id, uniqueness: {scope: :cohort_id}
end
