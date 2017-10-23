class AddSlugToClassProjects < ActiveRecord::Migration
  def change
    add_column :class_projects, :slug, :string

    execute "update class_projects set slug = name"

    change_column_null :class_projects, :slug, false
  end
end
