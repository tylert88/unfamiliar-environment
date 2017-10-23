class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.text :contents
      t.belongs_to :user, null: false, index: true
      t.belongs_to :learning_experience, null: false, index: true

      t.timestamps
    end
  end
end
