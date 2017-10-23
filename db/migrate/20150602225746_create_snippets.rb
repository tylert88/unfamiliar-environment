class CreateSnippets < ActiveRecord::Migration
  def change
    create_table :snippets do |t|
      t.integer :cohort_id
      t.string :name

      t.timestamps
    end
  end
end
