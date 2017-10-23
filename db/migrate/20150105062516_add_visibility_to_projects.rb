class AddVisibilityToProjects < ActiveRecord::Migration
  def change
    add_column :student_projects, :visibility, :integer, null: false, default: 0
    add_column :student_projects, :position, :integer, null: false, default: 0
  end
end
