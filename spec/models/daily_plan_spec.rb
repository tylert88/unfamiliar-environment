require "rails_helper"

describe DailyPlan do
  let(:daily_plan) { new_daily_plan(date: Time.zone.today) }

  describe ".next" do
    it "returns the next daily plan for a given cohort" do
      dp = DailyPlan.create!(cohort: daily_plan.cohort, date: Time.zone.tomorrow, description: 'Tomorrow')
      expect(daily_plan.next).to eq(dp)
    end

    it 'does not return one way off in the future' do
      dp = DailyPlan.create!(cohort: daily_plan.cohort, date: Time.zone.tomorrow, description: 'Tomorrow')
      dp2 = DailyPlan.create!(cohort: daily_plan.cohort, date: 1.year.from_now, description: 'Way future')
      expect(daily_plan.next).to eq(dp)
    end
  end

  describe '.prev' do
    it 'returns the previous daily plan for a given cohort' do
      dp = DailyPlan.create!(cohort: daily_plan.cohort, date: Time.zone.yesterday, description: 'Yesterday')
      expect(daily_plan.prev).to eq(dp)
    end
  end
end
