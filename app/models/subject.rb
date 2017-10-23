class Subject < ActiveRecord::Base
  has_many :learning_experiences
  belongs_to :curriculum

  default_scope ->{ order(:position) }

  before_validation on: :create do
    if curriculum && !position
      self.position = next_position
    end
  end

  def self.ordered
    order(:position)
  end

  private
  def next_position
    max_position = self.class.ordered.where(curriculum_id: curriculum_id).last.try(:position) || 0
    max_position + 1
  end
end
