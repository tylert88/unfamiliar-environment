class AddPolymorphicColumnsToZpds < ActiveRecord::Migration
  def change
    add_column :zpd_responses, :resource_id, :integer
    add_column :zpd_responses, :resource_type, :string
  end
end
