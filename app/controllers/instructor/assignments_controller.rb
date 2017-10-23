class Instructor::AssignmentsController < InstructorRequiredController

  include AssignmentsHelper

  def index
    @assignments = Assignment.where(cohort_id: params[:cohort_id]).order(:due_date)
  end

  def new
    @assignment = Assignment.new
  end

  def create
    @assignment = Assignment.new(assignment_params.merge(cohort_id: params[:cohort_id]))
    if @assignment.save
      AssignmentSubmission.seed_for_assignment(@assignment, @cohort)
      redirect_to instructor_cohort_assignments_path, notice: "Assignment Successfully Created"
    else
      render :new
    end
  end

  def edit
    @assignment = Assignment.find(params[:id])
  end

  def show
    @assignment = Assignment.find(params[:id])
    assignment_submissions = @assignment.assignment_submissions
    @submitted_assignment_submissions = assignment_submissions.select { |assignment_submission| assignment_submission.submitted && !assignment_submission.complete}
    @unsubmitted_assignment_submissions = assignment_submissions.select { |assignment_submission| !assignment_submission.submitted}
    @completed_assignment_submissions = assignment_submissions.select { |assignment_submission| assignment_submission.complete}
  end

  def update
    @assignment = Assignment.find(params[:id])
    if @assignment.update(assignment_params)
      redirect_to instructor_cohort_assignments_path, notice: "Assignment Successfully Updated"
    else
      render :edit
    end
  end

  def destroy
    Assignment.find(params[:id]).destroy
    redirect_to instructor_cohort_assignments_path, notice: "Assignment Destroyed"
  end

  private

  def assignment_params
    params.require(:assignment).permit(:name, :url, :due_date)
  end
end
