module  Api
  class AutograderController < BaseController

    def show

      if params[:cohort_id] && Cohort.find_by_id(params[:cohort_id])
        cohort_id = params[:cohort_id]
      end

      @enrollees = Enrollment.where(cohort_id: cohort_id).includes(:user)

      students_list = []
      @enrollees.each do |enrollee|
          record = Hash.new
          record[:student_name] = "#{enrollee.user.first_name} #{enrollee.user.last_name}"
          record[:email] = "#{enrollee.user.email}"
          record[:github_username] = "#{enrollee.user.github_username}"
          students_list << record
      end

      render json: students_list, serializer: nil
    end
  end
end
