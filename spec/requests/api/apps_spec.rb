require 'rails_helper'

describe "App authentication" do
  describe 'GET /api/apps/:app_name/authenticate' do
    let(:user) { create_instructor }

    it 'returns valid class project json' do
      post(
        "/api/apps/snippets/authenticate",
        {github_username: user.github_username}.to_json,
        {'X-App-Auth-Token' => Rails.application.config.snippet_app_auth_token}
      )

      response_json = JSON.parse(response.body, symbolize_names: true)
      expect(response_json[:auth_token]).to eq(user.auth_token)
    end
  end
end
