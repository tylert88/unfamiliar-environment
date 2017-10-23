class Instructor::AssignmentSubmissionNotesController < InstructorRequiredController
  def new
    @assignment_submission = AssignmentSubmission.find(params[:assignment_submission_id])
    @assignment_submission_note = AssignmentSubmissionNote.new
    @assignment_submission_notes = AssignmentSubmissionNote.where(assignment_submission_id: @assignment_submission.id)
  end

  def create
    @assignment_submission = AssignmentSubmission.find(params[:assignment_submission_id])
    @assignment_submission_note = AssignmentSubmissionNote.new(assignment_submission_note_params.merge(assignment_submission_id: params[:assignment_submission_id]))
    if @assignment_submission_note.save
      redirect_to instructor_cohort_assignment_path(@cohort.id, @assignment_submission.assignment.id), notice: "Note successfully added"
    else
      flash[:alert] = "Something went wrong"
      render :new
    end
  end

  def edit
    @assignment_submission = AssignmentSubmission.find(params[:assignment_submission_id])
    @assignment_submission_note = AssignmentSubmissionNote.find(params[:id])
  end

  def update
    @assignment_submission = AssignmentSubmission.find(params[:assignment_submission_id])
    @assignment_submission_note = AssignmentSubmissionNote.find(params[:id])
    if @assignment_submission_note.update(assignment_submission_note_params)
      redirect_to instructor_cohort_assignment_path(@cohort.id, @assignment_submission.assignment.id), notice: "Note successfully updated"
    else
      flash[:alert] = "Something went wrong"
      render :new
    end
  end

  def destroy
    AssignmentSubmissionNote.find(params[:id]).destroy
    @assignment_submission = AssignmentSubmission.find(params[:assignment_submission_id])
    redirect_to instructor_cohort_assignment_path(@cohort.id, @assignment_submission.assignment.id), notice: "Note destroyed"
  end

  private

  def assignment_submission_note_params
    params.require(:assignment_submission_note).permit(:content)
  end
end
