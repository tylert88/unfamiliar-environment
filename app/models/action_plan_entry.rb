class ActionPlanEntry < ActiveRecord::Base
  enum status: [ :unstarted, :in_progress, :completed, :abandoned ]
  belongs_to :user
  belongs_to :cohort
  belongs_to :learning_experience

  validate do
    unless description? || learning_experience
      errors[:base] << "You must add a learning experience or a description"
    end
  end
  validates :status, presence: true

  def self.for_cohort_and_user(cohort, user)
    where(cohort_id: cohort, user_id: user)
  end

end
