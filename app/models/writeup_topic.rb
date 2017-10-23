class WriteupTopic < ActiveRecord::Base

  belongs_to :cohort
  has_many :writeups, dependent: :destroy

  validates :cohort, presence: true
  validates :subject, presence: true

  scope :active, ->{where(active: true)}

  def students_who_completed
    writeups.map(&:user).uniq
  end

  def students_who_did_not_complete
    all_users = User.for_cohort(cohort)
    all_users - writeups.map(&:user)
  end

end
