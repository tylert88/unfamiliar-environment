class AddBioToEmploymentProfiles < ActiveRecord::Migration
  def change
    add_column :employment_profiles, :bio, :text
  end
end
