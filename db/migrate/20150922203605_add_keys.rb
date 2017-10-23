class AddKeys < ActiveRecord::Migration
  def change
    add_foreign_key "assignment_submissions", "users", name: "assignment_submissions_user_id_fk", dependent: :delete
  end
end
