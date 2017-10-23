class ChangeGradRequirementsToExpectations < ActiveRecord::Migration
  def change
    create_table :expectations do |t|
      t.belongs_to :course, null: false
      t.string :name, null: false
      t.index [:course_id, :name], unique: true
      t.string :description
      t.integer :position, null: false
      t.timestamps null: false
    end

    execute <<-SQL
      insert into expectations (course_id, name, description, position, created_at, updated_at)
      select course_id, name, description, position, created_at, updated_at
      from expectations;
    SQL
  end
end
