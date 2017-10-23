class GivenAssessmentsController < ApplicationController

  def index
    @given_assessments = @cohort.given_assessments
    authorize GivenAssessment
  end

  def show
    @given_assessment = @cohort.given_assessments.find(params[:id])
    authorize(@given_assessment)

    @users = User.for_cohort(@cohort)
    @taken_assessments_index = @given_assessment.taken_assessments.index_by(&:user_id)
  end

  def score
    @given_assessment = GivenAssessment.find(params[:given_assessment_id])
    authorize(@given_assessment)
    @users = User.for_cohort(@cohort).shuffle
    @question = @given_assessment.questions.detect do |question|
      question.id == params[:question_id]
    end
    @answers_indexed = Answer.where(
      taken_assessment_id: TakenAssessment.where(user_id: @users).finished,
      question_id: params[:question_id],
    ).index_by{|answer| answer.taken_assessment.user_id }
    @answers_indexed.values.each do |answer|
      unless answer.score
        if answer.response.present? && @question.answer.present? && answer.response.downcase.strip == @question.answer.downcase.strip
          answer.score = 1
        end
        if answer.response.blank?
          answer.score = 0
        end
      end
    end
  end

  def submit_scores
    @given_assessment = GivenAssessment.find(params[:given_assessment_id])
    authorize(@given_assessment)

    questions = @given_assessment.questions
    question = questions.detect{|question| question.id == params[:question_id]}

    params[:answers].each do |user_id, answer_attributes|
      taken_assessment = @given_assessment.taken_assessments.find_by!(
        user_id: user_id
      )
      answer = taken_assessment.answers.find_by!(question_id: params[:question_id])
      answer.update!(
        score: answer_attributes[:score],
        notes: answer_attributes[:notes]
      )
    end

    @given_assessment.update_statuses

    redirect_to(
      next_question_path_or_back(@given_assessment, questions),
      notice: "#{question.id} scores were recorded"
    )
  end

  def pull_changes
    @given_assessment = GivenAssessment.find_by_id(params[:id])
    authorize(@given_assessment)
    @given_assessment.update(markdown: @given_assessment.assessment.markdown)
    redirect_to cohort_given_assessment_path(@cohort, @given_assessment), notice: "Markdown was updated"
  end

  private def next_question_path_or_back(given_assessment, questions)
    index = questions.find_index do |question|
      question.id == params[:question_id]
    end
    if index == questions.length - 1
      cohort_given_assessment_path(@cohort, given_assessment)
    else
      cohort_given_assessment_score_path(@cohort, given_assessment, questions[index + 1].id)
    end
  end

  def create
    @assessment = Assessment.find(params[:assessment_id])
    @given_assessment = @assessment.given_assessments.new(given_assessment_params)
    @given_assessment.markdown = @assessment.markdown
    @given_assessment.name = @assessment.name
    @given_assessment.time_allowed_in_minutes = @assessment.time_allowed_in_minutes
    @given_assessment.css = @assessment.css
    authorize(@given_assessment)
    @given_assessment.save!
    redirect_to(
      cohort_given_assessment_path(@given_assessment.cohort, @given_assessment),
      notice: "Assessment was assigned to #{@given_assessment.cohort.name}"
    )
  end

  def destroy
    @given_assessment = GivenAssessment.find_by_id(params[:id])
    authorize(@given_assessment)
    @given_assessment.try(:destroy)
    redirect_to cohort_given_assessments_path(@cohort), notice: "Given Assessment was deleted"
  end

  def given_assessment_params
    params.require(:given_assessment).permit(
      :given_on,
      :cohort_id
    )
  end


end
