require 'rails_helper'

describe "Cohorts API" do
  describe 'GET /api/cohorts/current' do
    let(:user) { create_instructor }

    it 'returns valid cohort json' do
      cohort1 = create_cohort(start_date: 2.months.ago, end_date: 1.month.ago)
      cohort2 = create_cohort(start_date: 2.months.ago, end_date: 1.month.from_now)
      cohort3 = create_cohort(start_date: 2.months.ago, end_date: 1.month.from_now)

      get(
        "/api/cohorts/current",
        nil,
        {'X-Auth-Token' => user.auth_token}
      )

      response_json = JSON.parse(response.body, symbolize_names: true)
      expect(response_json[:cohorts].length).to eq(2)
      ids = response_json[:cohorts].map{|cohort| cohort[:id] }
      expect(ids).to match_array([cohort2.id, cohort3.id])
    end
  end
end
