class UserStudentChallengesPresenter
  attr_accessor :user, :student_challenge_presenters, :percent_passing, :complete

  def initialize(user, student_challenges)
    @user = user
    @student_challenge_presenters = student_challenges.map { |student_challenge| StudentChallengePresenter.new(student_challenge)}
    @complete = self.percent_passing == 1.0 ? true : false
  end

  def self.build_from_student_challenges(student_challenges)
    presenters = []
    users = student_challenges.map(&:user).uniq
    users.each do |user|
      student_challenges_for_user = student_challenges.select { |student_challenge| student_challenge.user_id == user.id}
      presenters << UserStudentChallengesPresenter.new(user, student_challenges_for_user)
    end
    presenters
  end

  def percent_passing
    passed = 0
    failed = 0
    @student_challenge_presenters.each do |student_challenge_presenter|
      passed += student_challenge_presenter.student_challenge.passed
      failed += student_challenge_presenter.student_challenge.failed
    end
    passed.to_f / (passed.to_f + failed.to_f)
  end
end
