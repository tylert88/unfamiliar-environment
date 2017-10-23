require 'rails_helper'

describe DailyPlansHelper do

  describe 'DailyPlanRenderer' do

    it "should handle empty header tags" do
      renderer = DailyPlansHelper::DailyPlanRenderer.new(DailyPlan.new(description: "#h1\n-\n-\n-"))
      renderer.parse
      expect{ renderer.content }.to_not raise_error
    end

  end

end
