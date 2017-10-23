class AddHeadlineToEmpoymentProfile < ActiveRecord::Migration
  def change
    add_column :employment_profiles, :headline, :string
  end
end
