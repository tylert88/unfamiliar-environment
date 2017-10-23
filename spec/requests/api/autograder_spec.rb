require 'rails_helper'

describe "autograder API" do
  describe 'GET /api/autograder/:cohort_id' do
    it 'returns json with all of the names, emails, and github_ids for each student' do

      user = create_instructor

      cohort = create_cohort(id: 1)
      student = create_student(
        cohort,
        first_name: 'Ajay',
        last_name: '1',
        email: 'user1@example.com',
        github_username: "someuser1"
      )

      student2 = create_student(
        cohort,
        first_name: 'Beana',
        last_name: '2',
        email: 'user2@example.com',
        github_username: "someuser2"
      )

      get(
        "/api/autograder/1",
        nil,
        {'X-Auth-Token' => user.auth_token}
      )

      response_json = JSON.parse(response.body, symbolize_names: true)

      expect(response_json).to eq([
        {
          student_name: "Ajay 1",
          email: 'user1@example.com',
          github_username: "someuser1",
        },
        {
          student_name: "Beana 2",
          email: 'user2@example.com',
          github_username: "someuser2",
        }
      ])
    end
  end
end
