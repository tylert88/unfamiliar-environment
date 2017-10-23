class TakenAssessment < ActiveRecord::Base

  enum status: [:in_progress, :finished, :scored]

  belongs_to :user
  belongs_to :given_assessment
  has_many :answers, dependent: :destroy

  validates :user, presence: true
  validates :given_assessment, presence: true, uniqueness: {scope: :user}
  validates :status, presence: true

  include MarkdownHelper

  def percent_scored
    return 0 if answers.empty? || scored_answers == 0
    scored_answers / answers.length.to_f
  end

  def score_info
    {
      answers: answers.length,
      scored_answers: scored_answers
    }
  end

  def scored_answers
    answers.select(&:scored?).length
  end

  def score
    answers.map{|answer| answer.score || 0 }.sum
  end

  def elapsed_time
    ended_at && ((ended_at - created_at) / 60).round(0)
  end

  def form_markdown
    parser = QuestionParser.new(markdownify(given_assessment.markdown))
    parser.form_markdown(answer_hash)
  end

  def display_markdown
    parser = QuestionParser.new(markdownify(given_assessment.markdown))
    parser.display_markdown(answer_hash)
  end

  private def answer_hash
    answers.reduce({}) do |result, answer|
      result[answer.question_id] = {
        response: answer.response,
        score: answer.score,
        notes: answer.notes,
      }
      result
    end
  end

end
