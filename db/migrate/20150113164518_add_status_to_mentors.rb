class AddStatusToMentors < ActiveRecord::Migration
  def change
    add_column :mentors, :status, :integer
    execute "update mentors set status = 0"
    change_column_null :mentors, :status, false
    add_index :mentors, :status
    add_index :mentors, :mentor_id
  end
end
