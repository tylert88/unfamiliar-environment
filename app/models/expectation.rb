class Expectation < ActiveRecord::Base

  belongs_to :course

  validates :name, presence: true, uniqueness: {case_sensitive: false, scope: :course}
  validates :position, numericality: true, uniqueness: {scope: :course}, presence: true
  validates :course, presence: true

  before_validation on: :create do
    if course && !position
      max_position = self.class.ordered.where(course_id: course).last.try(:position) || 0
      self.position = max_position + 1
    end
  end

  def self.ordered
    order(:position)
  end

  def self.for_cohort(cohort)
    where(course_id: cohort.course).ordered
  end

end
