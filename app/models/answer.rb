class Answer < ActiveRecord::Base

  belongs_to :taken_assessment

  validates :taken_assessment, presence: true
  validates :question_id, presence: true, uniqueness: {scope: :taken_assessment}

  def scored?
    score.present?
  end

end
