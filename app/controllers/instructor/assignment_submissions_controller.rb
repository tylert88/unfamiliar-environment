class Instructor::AssignmentSubmissionsController < InstructorRequiredController
  def toggle
    assignment_submission = AssignmentSubmission.find(params[:id])
    assignment_submission.toggle!(:complete)
    redirect_to instructor_cohort_assignment_path(@cohort, assignment_submission.assignment.id)
  end
end
