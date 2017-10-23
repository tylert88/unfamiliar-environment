class Mentorship < ActiveRecord::Base

  enum status: [:current, :previous]

  belongs_to :user
  belongs_to :mentor, class_name: 'User', foreign_key: :mentor_id

  validates :mentor, presence: true
  validates :user, presence: true
  validates :status, presence: true

  def self.mentee_cohorts_for(user)
    mentorships = Mentorship.current.where(mentor_id: user).includes(:user)
    users = mentorships.map(&:user)
    users.map(&:current_cohort)
  end

end
