class ExpectationStatus < ActiveRecord::Base

  belongs_to :user
  belongs_to :cohort
  belongs_to :expectation
  belongs_to :author, class_name: 'User', foreign_key: :author_id

  enum status: %i(draft published read)

  validates :user, presence: true
  validates :cohort, presence: true
  validates :expectation, presence: true
  validates :author, presence: true
  validates :notes, presence: true

end
