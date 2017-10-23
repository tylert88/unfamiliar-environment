class StudentChallengePresenter
  attr_accessor :user, :student_challenge, :percent_passing

  def initialize(student_challenge)
    @student_challenge = student_challenge
    @user = student_challenge.user

    @percent_passing = student_challenge.failed == 0 ? 100 : (student_challenge.passed.to_f/(student_challenge.passed.to_f + student_challenge.failed.to_f)*100)
  end
end
