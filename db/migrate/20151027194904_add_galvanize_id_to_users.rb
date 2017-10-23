class AddGalvanizeIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :galvanize_id, :integer
  end
end
