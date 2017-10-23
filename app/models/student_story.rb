class StudentStory < ActiveRecord::Base

  belongs_to :class_project
  belongs_to :epic
  belongs_to :story
  belongs_to :user

  validates :class_project, presence: true
  validates :user, presence: true, uniqueness: {scope: :story}
  validates :epic, presence: true
  validates :story, presence: true
  validates :current_state, presence: true

end
