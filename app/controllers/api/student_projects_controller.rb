module Api
  class StudentProjectsController < BaseController

    def index
      users = User.for_cohort(params[:cohort_id])
      class_project = ClassProject.find(params[:class_project_id])
      student_projects = StudentProject.where(user_id: users, class_project_id: class_project)
      render json: student_projects
    end

  end
end
