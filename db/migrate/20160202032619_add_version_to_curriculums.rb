class AddVersionToCurriculums < ActiveRecord::Migration
  def change
    add_column :curriculums, :version, :string
    execute "update curriculums set version = name"
    change_column :curriculums, :version, :string, null: false
    remove_index :curriculums, :name
    add_index :curriculums, [:name, :version], unique: true
  end
end
