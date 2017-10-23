class CohortEpic < ActiveRecord::Base

  belongs_to :epic
  belongs_to :cohort

  validates :epic, presence: true, uniqueness: {scope: :cohort}
  validates :cohort, presence: true

end
