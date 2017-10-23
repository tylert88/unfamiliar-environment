class CreateWriteupComments < ActiveRecord::Migration
  def change
    create_table :writeup_comments do |t|
      t.belongs_to :writeup, null: false
      t.belongs_to :user, null: false
      t.text :body, null: false
      t.timestamps null: false
    end
  end
end
