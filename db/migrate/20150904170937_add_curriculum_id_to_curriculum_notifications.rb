class AddCurriculumIdToCurriculumNotifications < ActiveRecord::Migration
  def change
    add_column :curriculum_notifications, :curriculum_id, :integer
  end
end
