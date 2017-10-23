require "rails_helper"

describe Challenge do
  describe ".new_from_json" do
    it "news up a challenge from json" do
      json = {'_id' => "1234asdf", 'directory_name' => "js-warmups", 'github_url' => "http://github.com"}
      challenge = Challenge.new_from_json(json)
      expect(challenge).to be_a(Challenge)
      expect(challenge.id).to eq("1234asdf")
      expect(challenge.directory_name).to eq "js-warmups"
      expect(challenge.github_url).to eq "http://github.com"
    end
  end

  describe ".all" do
    it "fetches challenges from the ENV[STUDENT_CHALLENGES_URL]" do
      VCR.use_cassette('challenges') do
        challenges = Challenge.get_all
        expect(challenges.length).to eq 17
        expect(challenges.first.id).to eq "55a04e30e061dc030083a4f8"
      end
    end
  end
end