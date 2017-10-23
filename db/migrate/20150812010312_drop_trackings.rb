class DropTrackings < ActiveRecord::Migration
  def change
    drop_table :trackings
    drop_table :student_trackings
  end
end
