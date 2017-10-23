class Assignment < ActiveRecord::Base
  has_many :assignment_submissions, dependent: :destroy
  validates :name, :due_date, presence: true
end
