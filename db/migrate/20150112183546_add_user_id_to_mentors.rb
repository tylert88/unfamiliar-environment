class AddUserIdToMentors < ActiveRecord::Migration
  def change
    add_column :mentors, :mentor_id, :integer
  end
end
