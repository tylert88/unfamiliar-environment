class Instructor::ActionPlansController < InstructorRequiredController

  def index
    @students = User.for_cohort(@cohort)
  end

end
