class CreateSubjects < ActiveRecord::Migration
  def change
    create_table :subjects do |t|
      t.timestamps
      t.string :name
      t.integer :curriculum_id
      t.integer :position
    end

    add_column :learning_experiences, :subject_id, :integer
  end
end
