class Story < ActiveRecord::Base

  belongs_to :epic
  validates :title, presence: true
  validates :position, presence: true, numericality: true
  validates :slug, uniqueness: {case_sensitive: false, scope: :epic, allow_nil: true}
  has_many :student_stories, dependent: :destroy

  before_validation do
    self.slug = slug.presence # turn empty strings to nil
  end

  before_validation on: :create do
    if epic && !position
      self.position = next_position
    end
  end

  before_validation on: :update do
    self.position = next_position if epic_id_changed?
  end

  def class_project
    epic.class_project
  end

  def next_position
    max_position = self.class.ordered.where(epic_id: epic_id).last.try(:position) || 0
    max_position + 1
  end

  def self.ordered
    order(:position)
  end

  def self.for_acceptor
    where(story_type: 'feature').where.not(slug: nil)
  end

end
