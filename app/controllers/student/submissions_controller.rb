class Student::SubmissionsController < ApplicationController

  def new
    @submission = Submission.new(
      exercise_id: params[:exercise_id]
    )
  end

  def create
    @submission = Submission.new(submission_params)

    if @submission.save
      redirect_to cohort_exercise_path(@cohort, @submission.exercise), :notice => "Your code has been submitted"
    else
      render :new
    end
  end

  def edit
    @submission = Submission.find(params[:id])
  end

  def update
    @submission = Submission.find(params[:id])

    if @submission.update(submission_params)
      redirect_to cohort_exercise_path(@cohort, @submission.exercise), :notice => "Your code has been submitted"
    else
      render :edit
    end
  end

  private

  def submission_params
    params.require(:submission).
      permit(:github_repo_name, :tracker_project_url).
      merge(:user_id => current_user.id, :exercise_id => params[:exercise_id])
  end
end
