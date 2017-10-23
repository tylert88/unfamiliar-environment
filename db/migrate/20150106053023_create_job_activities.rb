class CreateJobActivities < ActiveRecord::Migration
  def change
    create_table :job_activities do |t|
      t.belongs_to :user, null: false
      t.string :company, null: false
      t.string :position
      t.string :status
      t.date :date_of_last_interaction
      t.string :job_source
      t.string :url, limit: 1000
      t.timestamps
    end
  end
end
