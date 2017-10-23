class AddAssessingQuestionAnswersToPerformances < ActiveRecord::Migration
  def change
    add_column :performances, :assessing_question_answers, :json
  end
end
