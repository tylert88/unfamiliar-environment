class AddStoryTypeAndSlugToStories < ActiveRecord::Migration
  def change
    add_column :stories, :slug, :string
    add_index :stories, [:epic_id, :slug], unique: true
    add_column :stories, :story_type, :string, default: 'feature', null: false
  end
end
