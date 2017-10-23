require "rails_helper"

describe Student::ZpdResponsesController do
  describe "POST create" do
    it "creates a new response for a student" do
      cohort = create_cohort
      user = create_student(
        cohort,
        first_name: "Luke",
        last_name: "Skywalker",
        email: "luke@skywalker.com",
      )

      sign_in(user)
      expect {
        post :create, cohort_id: cohort.id, zpd_response: { response: 0, date: Date.current }
      }.to change { ZpdResponse.count }.by(1)

      zpd_response = ZpdResponse.last
      expect(zpd_response.response).to eq 0
    end
  end
end