class Instructor::ChallengesController < InstructorRequiredController
  def index
    @challenges = Challenge.where(cohort_id: @cohort.id)
  end

  def new
    @challenge = Challenge.new
  end

  def create
    @challenge = Challenge.new(challenge_params.merge(cohort_id: @cohort.id))
    if @challenge.save
      flash[:notice] = "Challenge Successfully Saved"
      redirect_to instructor_cohort_challenges_path(@cohort)
    else
      flash[:alert] = "Challenge could not be created"
      render :new
    end
  end

  def show
    @challenge = Challenge.find(params[:id])
    student_challenges = StudentChallenge.where(challenge_id: @challenge.id)
    @user_student_challenges_presenters = UserStudentChallengesPresenter.build_from_student_challenges(student_challenges)
    @completed_users = @user_student_challenges_presenters.select { |user_student_challenge_presenter| user_student_challenge_presenter.complete }.map(&:user)
    @students = User.for_cohort(@cohort)
    @incompleted_users = @students - @completed_users
  end

  private

  def challenge_params
    params.require(:challenge).permit(:directory_name, :github_url)
  end
end
