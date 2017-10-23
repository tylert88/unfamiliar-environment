class Assessment < ActiveRecord::Base

  validates :name, presence: true, uniqueness: {case_sensitive: false}
  validates :time_allowed_in_minutes, presence: true, numericality: true
  has_many :given_assessments, dependent: :nullify

  validate :check_questions

  include MarkdownHelper

  def form_preview_markdown
    parser = QuestionParser.new(markdownify(markdown))
    parser.form_preview_markdown
  end

  def questions
    parser = QuestionParser.new(markdownify(markdown))
    parser.questions
  end

  private def check_questions
    questions = self.questions
    question_ids = questions.map(&:id)
    dupes = question_ids.select{ |id| question_ids.count(id) > 1 }
    dupes.uniq.each do |dupe|
      errors[:base] << "Found duplicate id #{dupe}"
    end
  end

end
