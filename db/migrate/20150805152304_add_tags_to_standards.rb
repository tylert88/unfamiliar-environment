class AddTagsToStandards < ActiveRecord::Migration
  def change
    add_column :standards, :tags, :json
  end
end
