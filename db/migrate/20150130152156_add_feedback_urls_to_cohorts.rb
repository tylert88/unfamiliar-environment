class AddFeedbackUrlsToCohorts < ActiveRecord::Migration
  def change
    add_column :cohorts, :daily_feedback_url, :string
    add_column :cohorts, :weekly_feedback_url, :string
  end
end
