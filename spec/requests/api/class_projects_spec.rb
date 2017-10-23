require 'rails_helper'

describe "Class projects API" do
  describe 'GET /api/class_projects' do
    let(:user) { create_instructor }

    it 'returns valid class project json' do
      class_project1 = create_class_project
      class_project2 = create_class_project

      get(
        "/api/class_projects",
        nil,
        {'X-Auth-Token' => user.auth_token}
      )

      response_json = JSON.parse(response.body, symbolize_names: true)
      expect(response_json[:class_projects].length).to eq(2)
      ids = response_json[:class_projects].map{|class_project| class_project[:id] }
      expect(ids).to match_array([class_project1.id, class_project2.id])
    end
  end
end
