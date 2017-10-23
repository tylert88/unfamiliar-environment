class CreateLearningExperiences < ActiveRecord::Migration
  def change
    create_table :learning_experiences do |t|
      t.belongs_to :curriculum, null: false, index: true
      t.string :name, null: false
      t.text :description
      t.integer :position, null: false
      t.timestamps null: false
    end
  end
end
