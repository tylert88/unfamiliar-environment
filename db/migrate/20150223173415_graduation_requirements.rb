class GraduationRequirements < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :name, null: false
      t.index :name, unique: true
      t.timestamps null: false
    end

    execute "insert into courses (name, created_at, updated_at) values ('Fullstack', now(), now())"

    add_column :cohorts, :course_id, :integer
    add_index :cohorts, :course_id

    execute "update cohorts set course_id = (select id from courses limit 1)"

    change_column_null :cohorts, :course_id, false

    create_table :graduation_requirements do |t|
      t.belongs_to :course, null: false
      t.string :name, null: false
      t.index [:course_id, :name], unique: true
      t.string :description
      t.integer :position, null: false
      t.timestamps null: false
    end
  end
end
