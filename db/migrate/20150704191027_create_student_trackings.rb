class CreateStudentTrackings < ActiveRecord::Migration
  def change
    create_table :student_trackings do |t|
      t.integer :tracking_id
      t.integer :user_id
      t.json :results

      t.timestamps null: false
    end
  end
end
