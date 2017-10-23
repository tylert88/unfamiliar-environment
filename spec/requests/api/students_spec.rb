require 'rails_helper'

describe "Students API" do
  describe 'GET /api/cohorts/:cohort_id/students' do
    before do
      user = create_instructor
      mock_omniauth(info_overrides: {email: user.email, nickname: user.github_username})
      get_via_redirect "/auth/github"
    end

    it 'returns valid student json' do
      cohort = create_cohort
      student1 = create_student(
        cohort,
        email: 'user1@example.com',
        github_username: "someuser1"
      )
      student2 = create_student(
        cohort,
        email: 'user2@example.com',
        github_username: "someuser2"
      )

      get "/api/cohorts/#{cohort.to_param}/students"

      response_json = JSON.parse(response.body, symbolize_names: true)
      expect(response_json[:students].length).to eq(2)
      usernames = response_json[:students].map{|user| user[:github_username] }
      expect(usernames).to match_array(["someuser1", "someuser2"])
    end
  end
end
