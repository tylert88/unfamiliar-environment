class AddLastResponseJsonToStudentStories < ActiveRecord::Migration
  def change
    add_column :student_stories, :last_response_json, :json
  end
end
