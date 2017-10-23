class PopulateEnrollments < ActiveRecord::Migration

  class MigrationUser < ActiveRecord::Base
    self.table_name = :users
  end

  class MigrationEnrollment < ActiveRecord::Base
    self.table_name = :enrollments
  end

  def change
    MigrationUser.all.each do |user|
      if user.cohort_id
        MigrationEnrollment.create!(
          user_id: user.id,
          cohort_id: user.cohort_id,
          status: user.status,
          role: user.role,
        )
      end
    end
  end
end
