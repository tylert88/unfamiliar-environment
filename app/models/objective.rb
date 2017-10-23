class Objective < ActiveRecord::Base
  belongs_to :standard
  has_many :experience_objectives, dependent: :destroy
  has_many :learning_experiences, through: :experience_objectives
  has_many :questions
  validates :name, presence: true, uniqueness: {scope: :standard_id, case_sensitive: false}
  validates :standard, presence: true
  has_many :performances, dependent: :destroy
  has_many :exercise_objectives, dependent: :destroy
  has_many :exercises, through: :exercise_objectives

  accepts_nested_attributes_for :questions, reject_if: proc { |attributes| attributes['question'].blank? }

  attr_accessor :user_id

  default_scope ->{order(:position)}

  UNMEASURABLE_VERBS = %w(know understand learn grasp)
  UNMEASURABLE_VERBS_REGEX = Regexp.new("^(#{UNMEASURABLE_VERBS.join("|")})", Regexp::IGNORECASE)

  validate do
    if name.to_s =~ UNMEASURABLE_VERBS_REGEX
      errors[:name] << "can't start with a non-measurable verb"
    end
  end

  before_validation do
    if standard_id_changed? && standard && !position
      self.position = next_position
    end
  end

  def next_position
    max_position = self.class.ordered.where(standard_id: standard_id).last.try(:position) || 0
    max_position + 1
  end

  def self.ordered
    order(:position)
  end
end
