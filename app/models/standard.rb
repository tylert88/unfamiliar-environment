class Standard < ActiveRecord::Base
  has_many :objectives, dependent: :destroy
  has_many :exercises, through: :objectives
  has_many :performances, through: :objectives
  belongs_to :curriculum
  belongs_to :subject
  validates :name, presence: true, uniqueness: {case_sensitive: false, scope: :curriculum_id}

  attr_accessor :user_id

  before_validation on: :create do
    if curriculum && !position
      self.position = next_position
    end
  end

  def next_position
    max_position = self.class.ordered.where(curriculum_id: curriculum_id).last.try(:position) || 0
    max_position + 1
  end

  def self.ordered
    order(:position)
  end

end
