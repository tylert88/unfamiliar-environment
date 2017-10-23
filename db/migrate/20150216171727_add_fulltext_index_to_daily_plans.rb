class AddFulltextIndexToDailyPlans < ActiveRecord::Migration
  def change
    execute "CREATE INDEX daily_plans_idx ON daily_plans USING gin(to_tsvector('english', description));"
  end
end
