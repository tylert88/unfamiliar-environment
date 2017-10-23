require "rails_helper"

describe StudentChallenge do
  describe ".new_from_json" do
    it "news up a student challenge from json" do
      json = {'challenge_id' => "1234asdf", 'auth_token' => "asdf4321", 'passing' => 4, 'failing' => 0}

      student_challenge = StudentChallenge.new_from_json(json)
      expect(student_challenge).to be_a(StudentChallenge)
      expect(student_challenge.challenge_id).to eq "1234asdf"
      expect(student_challenge.auth_token).to eq "asdf4321"
      expect(student_challenge.passing).to eq 4
      expect(student_challenge.failing).to eq 0
    end
  end

  describe ".for_user" do
    it "retrieves the student challenges from the ENV[STUDENT_CHALLENGES_URL]" do

      user = create_user
      user.auth_token = "foo_token"

      VCR.use_cassette("student_challenges") do
        student_challenges = StudentChallenge.for_user(user)
        expect(student_challenges.length).to eq 9
      end
    end
  end
end