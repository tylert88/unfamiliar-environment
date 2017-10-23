class Enrollment < ActiveRecord::Base

  enum role: [ :student ]
  enum status: [ :enrolled, :graduated, :completed_without_guarantee, :withdrew, :asked_to_leave ]

  belongs_to :user
  belongs_to :cohort

  validates :user, presence: true, uniqueness: {scope: [:cohort, :role]}
  validates :cohort, presence: true
  validates :role, presence: true
  validates :status, presence: true

end
