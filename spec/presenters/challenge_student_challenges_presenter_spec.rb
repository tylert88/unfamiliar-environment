require "rails_helper"

describe ChallengeStudentChallengesPresenter do
  describe ('.build_from') do
    it "returns a collection of data" do
      challenges = [Challenge.new("123", "word-weight", "http://github.com"), Challenge.new("456", "js-fundamentals", "http://github.com")]
      student_challenges = [StudentChallenge.new("123", "auth_tok123", 4, 0)]
      challenge_student_challenges_presenter = ChallengeStudentChallengesPresenter.build_from(challenges, student_challenges)

      expect(challenge_student_challenges_presenter.challenges).to eq([
        {
          challenge_id: "123",
          directory_name: 'word-weight',
          github_url: 'http://github.com',
          passing: 4,
          failing: 0,
          complete: true,
          percent_passing: 100.0
        },
        {
          challenge_id: '456',
          directory_name: 'js-fundamentals',
          github_url: 'http://github.com',
          passing: 0,
          failing: 1,
          complete: false,
          percent_passing: 0.0
        }
      ])
    end
  end
end