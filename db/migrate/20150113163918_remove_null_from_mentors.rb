class RemoveNullFromMentors < ActiveRecord::Migration
  def change
    change_column_null :mentors, :first_name, true
    change_column_null :mentors, :last_name, true
    change_column_null :mentors, :email, true
  end
end
