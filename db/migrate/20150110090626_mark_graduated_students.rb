class MarkGraduatedStudents < ActiveRecord::Migration
  def change
    cohort_ids = Cohort.where('end_date < now()').pluck(:id)
    if cohort_ids.any?
      execute "update enrollments set status = 1 where cohort_id in (#{cohort_ids.join(",")})"
    end
  end
end
