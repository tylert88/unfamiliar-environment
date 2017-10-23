class Instructor::StudentDashboardController < ApplicationController
  def show
    authorize :student_dashboard, :show?
    @user = User.find(params[:id])

    challenges = Challenge.get_all
    student_challenges = StudentChallenge.for_user(@user)

    @challenge_student_challenges_presenter = ChallengeStudentChallengesPresenter.build_from(challenges, student_challenges)

    @zpd_responses = ZpdResponse.where(user_id: @user.id).reverse_order
    @zpd_response_data = ZpdResponse.gather_data_for_user(@user.id)
  end
end