class AddSubjectIdToStandards < ActiveRecord::Migration
  def change
    add_column :standards, :subject_id, :integer

    execute <<-SQL
      ALTER TABLE standards
        ADD CONSTRAINT fk_standards_subject_id
        FOREIGN KEY (subject_id) REFERENCES subjects (id)
        ON DELETE RESTRICT;
    SQL
  end
end
