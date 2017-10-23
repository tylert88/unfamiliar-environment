class TakenAssessmentsController < ApplicationController

  before_action do
    @user = User.find(params[:user_id])
  end

  def index
    @given_assessments = GivenAssessment.where(cohort_id: @user.current_cohort)
    @taken_assessments = TakenAssessment.where(user_id: @user)
    @in_progress_assessments = @taken_assessments.select(&:in_progress?)
    @finished_assessments = @taken_assessments.select(&:finished?)
    @scored_assessments = @taken_assessments.select(&:scored?)
    @assessments_to_take = @given_assessments.reject do |given_assessment|
      @taken_assessments.detect{|taken_assessment| taken_assessment.given_assessment_id == given_assessment.id }
    end
  end

  def new
    @given_assessment = GivenAssessment.find_by!(
      id: params[:given_assessment_id],
      cohort_id: @user.current_cohort,
    )
    taken_assessment = TakenAssessment.find_by(
      user_id: @user.id,
      given_assessment_id: @given_assessment_id
    )
    if taken_assessment
      redirect_to(
        user_taken_assessment_path(@user),
        notice: "You already started this assessment"
      )
    else
      taken_assessment = TakenAssessment.create!(
        user: @user,
        given_assessment: @given_assessment,
        status: :in_progress,
      )
      authorize(taken_assessment)
      redirect_to(
        edit_user_taken_assessment_path(@user, taken_assessment),
        notice: "Good luck!  May the odds be ever in your favor."
      )
    end
  end

  def show
    @taken_assessment = TakenAssessment.find_by!(id: params[:id], user_id: @user.id)
    authorize(@taken_assessment)
  end

  def edit
    @taken_assessment = TakenAssessment.find_by!(id: params[:id], user_id: @user.id)
    authorize(@taken_assessment)
  end

  def update
    @taken_assessment = TakenAssessment.find_by!(id: params[:id], user_id: @user.id)
    authorize(@taken_assessment)

    Answer.transaction do
      params[:answers].each do |question_id, text|
        answer = Answer.find_or_initialize_by(
          taken_assessment_id: @taken_assessment.id,
          question_id: question_id
        )
        answer.update!(response: text)
      end
    end

    redirect_to(
      user_taken_assessment_path(@user, @taken_assessment),
      notice: "Assessment was saved",
    )
  end

  def submit
    @taken_assessment = TakenAssessment.find_by!(id: params[:id], user_id: @user.id)
    authorize(@taken_assessment)
    @taken_assessment.update!(
      status: :finished,
      ended_at: Time.current
    )
    redirect_to(
      user_taken_assessment_path(@user, @taken_assessment),
      notice: "Assessment was submitted!",
    )
  end

  def track
    @taken_assessment = TakenAssessment.find_by!(id: params[:id], user_id: @user.id)
    authorize(@taken_assessment)
    data = @taken_assessment.focus_history || []
    data = data.dup
    data << {
      created_at: Time.current,
      event: params["event"]
    }
    @taken_assessment.update(focus_history: data)
    render nothing: true
  end

  helper_method def assessments_in_progress
    []
  end

end
