module Api
  class StudentsController < BaseController

    def index
      cohort = Cohort.find(params[:cohort_id])
      students = User.for_cohort(cohort)
      render json: students
    end

  end
end
