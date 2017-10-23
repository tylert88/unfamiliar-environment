class Epic < ActiveRecord::Base

  enum category: [:mvp, :stretch]

  belongs_to :class_project
  has_many :stories, :dependent => :destroy
  has_many :student_stories, :dependent => :destroy
  has_many :cohort_epics, :dependent => :destroy

  validates :class_project, presence: true
  validates :name,
            presence: true,
            uniqueness: {scope: [:class_project_id, :category], case_sensitive: false}
  validates :position,
            presence: true,
            numericality: true,
            uniqueness: {scope: :class_project_id}

  before_validation on: :create do
    if class_project && !position
      max_position = self.class.ordered.where(class_project_id: class_project).last.try(:position) || 0
      self.position = max_position + 1
    end
  end

  def self.ordered
    order(:position)
  end

end
