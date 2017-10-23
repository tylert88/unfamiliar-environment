class DropSlugIndexOnStories < ActiveRecord::Migration
  def change
    remove_index :stories, [:epic_id, :slug]
  end
end
