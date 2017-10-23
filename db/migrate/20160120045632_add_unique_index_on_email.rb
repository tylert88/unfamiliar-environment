class AddUniqueIndexOnEmail < ActiveRecord::Migration
  def change
    execute "CREATE UNIQUE INDEX ON users ((lower(email)));"
  end
end
