require 'rails_helper'

describe "Students API" do
  describe 'GET /api/student_projects' do
    let(:user){ create_instructor }

    it 'returns valid student json' do
      cohort = create_cohort
      cohort2 = create_cohort
      class_project = create_class_project(name: "gCamp")
      student1 = create_student(
        cohort,
        email: 'user1@example.com',
        github_username: "someuser1"
      )
      student2 = create_student(
        cohort2,
        email: 'user2@example.com',
        github_username: "someuser2"
      )
      StudentProject.create!(
        name: 'gCamp',
        class_project: class_project,
        user: student1,
        tracker_url: 'http://tracker.example.com',
      )
      StudentProject.create!(
        name: 'gCamp',
        class_project: class_project,
        user: student2,
        tracker_url: 'http://other.example.com',
      )

      get(
        "/api/student_projects?cohort_id=#{cohort.id}&class_project_id=#{class_project.id}",
        nil,
        {'X-Auth-Token' => user.auth_token}
      )

      response_json = JSON.parse(response.body, symbolize_names: true)
      expect(response_json[:student_projects].length).to eq(1)

      student_project = response_json[:student_projects].first
      expect(student_project[:tracker_url]).to eq('http://tracker.example.com')
    end
  end
end
