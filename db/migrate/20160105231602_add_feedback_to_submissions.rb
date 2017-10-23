class AddFeedbackToSubmissions < ActiveRecord::Migration
  def change
    add_column :submissions, :feedback, :json
    add_column :submissions, :feedback_given, :boolean, default: false
  end
end
