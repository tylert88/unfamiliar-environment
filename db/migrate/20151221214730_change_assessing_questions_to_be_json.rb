class ChangeAssessingQuestionsToBeJson < ActiveRecord::Migration
  def change
    remove_column :objectives, :assessing_questions, :text
    create_table :questions do |q|
      q.integer :objective_id
      q.string :question_type
      q.string :question
      q.text :answers, array: true, default: []
      q.string :correct_answer
      q.timestamps
    end
  end
end
