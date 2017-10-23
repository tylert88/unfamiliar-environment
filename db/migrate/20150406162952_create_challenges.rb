class CreateChallenges < ActiveRecord::Migration
  def change
    create_table :challenges do |t|
      t.string :directory_name, null: false
      t.string :github_url, null: false
      t.integer :cohort_id, null: false

      t.timestamps null: false
    end
  end
end
