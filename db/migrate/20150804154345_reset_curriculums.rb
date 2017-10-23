class ResetCurriculums < ActiveRecord::Migration
  def change
    execute "delete from curriculums"
    execute <<-SQL
      insert into curriculums (name, description, created_at, updated_at)
      values ('Full Stack', 'Backwards-planned, JS-based', now(), now())
    SQL
  end
end
