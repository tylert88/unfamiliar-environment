class ChangeMentorToMentorship < ActiveRecord::Migration
  def change
    create_table "mentorships" do |t|
      t.integer  "user_id", null: false
      t.integer  "mentor_id", null: false
      t.integer  "status", null: false
      t.string   "company_name"
      t.timestamps
    end
  end
end
