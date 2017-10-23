class AddResourcesToStandards < ActiveRecord::Migration
  def change
    add_column :standards, :resources, :text
    add_column :standards, :guiding_questions, :text
    add_column :standards, :description, :text
  end
end
