class CreateCurriculumNotifications < ActiveRecord::Migration
  def change
    create_table :curriculum_notifications do |t|
      t.integer :user_id
      t.string :resource_type
      t.integer :resource_id
      t.string :resource_name
      t.integer :status

      t.timestamps
    end
  end
end
