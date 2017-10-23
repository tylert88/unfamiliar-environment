require "rails_helper"

describe Student::StudentDashboardController do
  let(:cohort) { create_cohort }
  let(:user) {
      user = create_student(
      cohort,
      first_name: "Luke",
      last_name: "Skywalker",
      email: "luke@skywalker.com",
    )
  }
  describe "GET index" do
    it "assigns zpd responses and daily plans when hit without a query parameter" do
      sign_in(user)

      yesterday_daily_plan = create_daily_plan(date: Date.yesterday, cohort_id: cohort.id)
      zpd_response = create_zpd_response(user_id: user.id)

      get :index, cohort_id: cohort.id

      expect(assigns(:daily_plan)).to be_a_new(DailyPlan)
      expect(assigns(:daily_plans)).to eq [yesterday_daily_plan]
      expect(assigns(:zpd_responses)).to eq [zpd_response]
    end
  end
end
