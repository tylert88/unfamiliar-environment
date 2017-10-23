class AddAssignmentResponseType < ActiveRecord::Migration
  def change
    add_column :exercises, :response_type, :integer, default: 0
    add_column :submissions, :contents, :text
  end
end
