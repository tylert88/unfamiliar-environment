class Instructor::ActionPlanEntriesController < InstructorRequiredController

  before_action do
    @user = User.for_cohort(@cohort).find(params[:student_id])
    if @cohort.curriculum_id
      @learning_experiences = LearningExperience.where(curriculum_id: @cohort.curriculum_id).ordered
    end
  end

  def index
    @entries = ActionPlanEntry.for_cohort_and_user(@cohort, @user).order('created_at desc')
  end

  def new
    @entry = ActionPlanEntry.new
  end

  def create
    @entry = ActionPlanEntry.new(entry_params)
    @entry.user = @user
    @entry.cohort = @cohort

    if @entry.save
      StudentMailer.action_plan_entry(current_user, @entry).deliver
      redirect_to(
        instructor_cohort_student_action_plan_entries_path(@cohort, @user),
        notice: 'Entry created successfully'
      )
    else
      render :new
    end
  end

  def edit
    @entry = ActionPlanEntry.for_cohort_and_user(@cohort, @user).find(params[:id])
  end

  def update
    @entry = ActionPlanEntry.for_cohort_and_user(@cohort, @user).find(params[:id])

    if @entry.update(entry_params)
      StudentMailer.action_plan_entry(current_user, @entry).deliver
      redirect_to(
        instructor_cohort_student_action_plan_entries_path(@cohort, @user),
        notice: 'Entry updated successfully'
      )
    else
      render :edit
    end
  end

  def destroy
    @entry = ActionPlanEntry.for_cohort_and_user(@cohort, @user)
      .find_by_id(params[:id])
      .try(:destroy)

    redirect_to(
      instructor_cohort_student_action_plan_entries_path(@cohort, @user),
      notice: 'Entry deleted successfully'
    )
  end

  private

  def entry_params
    params.require(:action_plan_entry).permit(
      :description,
      :learning_experience_id,
      :status,
      :due_on,
      :completed_on,
      :started_on,
    )
  end

end
