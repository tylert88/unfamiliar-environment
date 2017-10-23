class LearningExperience < ActiveRecord::Base
  belongs_to :curriculum
  belongs_to :subject
  has_many :experience_objectives, dependent: :destroy
  has_many :objectives, through: :experience_objectives
  has_many :notes, dependent: :destroy
  has_many :zpd_responses, as: :resource
  validates :curriculum, presence: true
  validates :name, presence: true, uniqueness: {scope: :curriculum_id, case_sensitive: false}

  attr_accessor :user_id

  default_scope ->{ order(:position) }
  scope :mainline, ->{ where(mainline: true) }

  before_validation on: :create do
    if curriculum && !position
      self.position = next_position
    end
  end

  def self.for_standard(standard)
    joins(:experience_objectives)
      .references(:experience_objectives)
      .where(experience_objectives: {objective_id: standard.objective_ids})
      .ordered
      .includes(:objectives)
      .uniq
  end

  def self.ordered
    order(:position)
  end

  def name_with_duration
    name
  end

  private def next_position
    max_position = self.class.ordered.where(curriculum_id: curriculum_id).last.try(:position) || 0
    max_position + 1
  end

end
