class AddScoreToWriteups < ActiveRecord::Migration
  def change
    add_column :writeups, :score, :integer
    add_index :writeups, :score
  end
end
