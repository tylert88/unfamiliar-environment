class AddPositionToSubjects < ActiveRecord::Migration
  def up
    position = 0;
    Subject.all.each do |subj|
      subj.update_attribute(:position, position)
      position += 1
    end
  end

  def down
  end
end
