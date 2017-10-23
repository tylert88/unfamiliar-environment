class GivenAssessment < ActiveRecord::Base

  belongs_to :cohort
  belongs_to :assessment
  has_many :taken_assessments, dependent: :destroy

  validates :cohort, presence: true
  validates :given_on, presence: true
  validates :markdown, presence: true
  validates :name, presence: true
  validates :time_allowed_in_minutes, presence: true

  include MarkdownHelper

  def update_statuses
    taken_assessments.each do |taken_assessment|
      answers = taken_assessment.answers
      if answers.length == questions.length && answers.all?(&:scored?)
        taken_assessment.update(status: :scored)
      end
    end
  end

  def question_info(question)
    answers = taken_assessments
      .flat_map(&:answers)
      .group_by(&:question_id)[question.id] || []

    {
      incorrect: answers.select(&:scored?).select{|answer| answer.score == 0 }.length,
      correct: answers.select(&:scored?).select{|answer| answer.score > 0 }.length,
      scored: answers.select(&:scored?).length,
      taken: User.for_cohort(cohort).length,
    }
  end

  def score_info
    potential = questions.length * taken_assessments.length
    scored = 0
    taken_assessments.each do |taken_assessment|
      scored += taken_assessment.scored_answers
    end
    return 0 if scored == 0
    ((scored / potential.to_f) * 100).round(0)
  end

  def potential_score
    questions.reject{|question| question.bonus }.length
  end

  def questions
    parser = QuestionParser.new(markdownify(markdown))
    parser.questions
  end

  def first_question
    parser = QuestionParser.new(markdownify(markdown))
    parser.questions.first
  end

  def form_preview_markdown
    parser = QuestionParser.new(markdownify(markdown))
    parser.form_preview_markdown
  end

end
