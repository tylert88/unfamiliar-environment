class AddQuestionsAndResourcesToObjectives < ActiveRecord::Migration
  def change
    add_column :objectives, :description, :text
    add_column :objectives, :guiding_questions, :text
    add_column :objectives, :resources, :text
  end
end
