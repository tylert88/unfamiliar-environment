class AddQuestionsToSuccessCriteria < ActiveRecord::Migration
  def change
    add_column :objectives, :assessing_questions, :text
  end
end
