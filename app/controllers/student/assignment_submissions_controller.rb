class Student::AssignmentSubmissionsController < ApplicationController
  def index
    @assignment_submissions = AssignmentSubmission.where(user_id: current_user.id).order(:id)
  end

  def edit
    @assignment_submission = AssignmentSubmission.find(params[:id])
  end

  def update
    @assignment_submission = AssignmentSubmission.find(params[:id])
    if !@assignment_submission.submitted
      @assignment_submission.update(edit_assignment_submission_params.merge(submitted: true))
      @assignment_submission.update(created_at: Time.now)
    else
      @assignment_submission.update(edit_assignment_submission_params.merge(submitted: true))
    end
    redirect_to cohort_assignment_submissions_path(@cohort), notice: "Assignment Submitted"
  end

  def show
    @assignment_submission = AssignmentSubmission.find(params[:id])
    @assignment_submission_notes = AssignmentSubmissionNote.where(assignment_submission_id: @assignment_submission.id)
  end

  private

  def edit_assignment_submission_params
    params.require(:assignment_submission).permit(:submission_url, :time_spent)
  end
end
