class DailyPlan < ActiveRecord::Base

  belongs_to :cohort

  validates :cohort, presence: true
  validates :date, presence: true, uniqueness: {scope: :cohort_id}
  validates :description, presence: true

  def self.search(query)
    where("to_tsvector('english', description) @@ to_tsquery(?)", query.split(" ").map(&:strip).join(" & "))
  end

  def self.ordered
    order('date desc')
  end

  def self.grouped_by_week(daily_plans)
    grouped_plans = daily_plans.group_by do |plan|
      [plan.date.strftime("%G").to_i, plan.date.strftime("%V").to_i]
    end

    grouped_plans.sort_by(&:first).map.with_index(1) do |(_, days), week_number|
      [week_number, days.sort_by(&:date)]
    end.reverse
  end

  def next
    DailyPlan.order('date asc').where('date > ?', self.date).where(cohort: self.cohort).limit(1).first
  end

  def prev
    DailyPlan.ordered.where('date < ?', self.date).where(cohort: self.cohort).limit(1).first
  end

  def to_param
    date.strftime("%Y-%m-%d")
  end

end
