class ExperienceObjective < ActiveRecord::Base

  belongs_to :learning_experience
  belongs_to :objective

  validates :learning_experience, presence: true
  validates :objective_id, presence: true, uniqueness: {scope: :learning_experience_id}

end
