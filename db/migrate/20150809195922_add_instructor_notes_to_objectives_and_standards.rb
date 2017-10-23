class AddInstructorNotesToObjectivesAndStandards < ActiveRecord::Migration
  def change
    add_column :standards, :instructor_notes, :text
    add_column :objectives, :instructor_notes, :text
  end
end
