class Instructor::ProjectsController < InstructorRequiredController

  def index
    @projects = StudentProject.for_user(User.for_cohort(@cohort))
                  .sort_by{|project| project.user.full_name }
  end

end
