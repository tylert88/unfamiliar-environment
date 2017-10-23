class ChallengeStudentChallengesPresenter
  attr_accessor :complete, :challenge, :student_challenges, :challenges

  def self.build_from(challenges, student_challenges)
    presenter = ChallengeStudentChallengesPresenter.new
    presenter.challenges = challenges.map do |challenge|
      student_challenge = student_challenges.find{ |student_challenge| student_challenge.challenge_id == challenge.id }
      if student_challenge
        {
          challenge_id: challenge.id,
          directory_name: challenge.directory_name,
          github_url: challenge.github_url,
          passing: student_challenge.passing,
          failing: student_challenge.failing,
          complete: student_challenge.failing == 0,
          percent_passing: student_challenge.passing == 0 ? 0.0 :(student_challenge.passing.to_f / (student_challenge.passing.to_f + student_challenge.failing.to_f))*100
        }
      else
        {challenge_id: challenge.id, directory_name: challenge.directory_name, github_url: challenge.github_url, passing: 0, failing: 1, complete: false, percent_passing: 0.0}
      end
    end
    presenter
  end
end
