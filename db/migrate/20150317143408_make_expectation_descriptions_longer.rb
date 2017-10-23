class MakeExpectationDescriptionsLonger < ActiveRecord::Migration
  def change
    change_column :expectations, :description, :text
  end
end
