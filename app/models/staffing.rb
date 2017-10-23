class Staffing < ActiveRecord::Base

  enum :status => [:active, :inactive]

  belongs_to :user
  belongs_to :cohort

  validates :user, presence: true, uniqueness: {scope: :cohort_id}
  validates :cohort, presence: true
  validates :status, presence: true

end
