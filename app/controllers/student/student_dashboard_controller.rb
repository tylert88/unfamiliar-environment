class Student::StudentDashboardController < ApplicationController
  def index
    @cohort = Cohort.find(params[:cohort_id])
    redirect_to root_path unless current_user.cohorts.include?(@cohort)
    @daily_plan = DailyPlan.find_or_initialize_by(
      date: Date.current.to_s,
      cohort_id: @cohort.id
    )
    @daily_plans = DailyPlan.where(:created_at => @daily_plan.date.advance(weeks: -2)..@daily_plan.date.advance(weeks:1), cohort_id: @cohort.id)
    @zpd_response_data = ZpdResponse.gather_data_for_user(current_user.id)
    @todays_zpd_response = ZpdResponse.find_by(user_id: current_user.id, date: Date.today)
    @zpd_responses = ZpdResponse.where(user_id: current_user.id).order(created_at: :desc).limit(10)
  end

  def js_challenges
    challenges = Challenge.get_all
    student_challenges = StudentChallenge.for_user(current_user)

    @challenge_student_challenges_presenter = ChallengeStudentChallengesPresenter.build_from(challenges, student_challenges)
  end
end
