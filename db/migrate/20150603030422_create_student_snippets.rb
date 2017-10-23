class CreateStudentSnippets < ActiveRecord::Migration
  def change
    create_table :student_snippets do |t|
      t.integer :snippet_id
      t.text :body
      t.integer :user_id

      t.timestamps
    end
  end
end
