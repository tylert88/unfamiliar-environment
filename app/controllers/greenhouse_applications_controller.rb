class GreenhouseApplicationsController < InstructorRequiredController

  def index
    @applications = GreenhouseApplication.where(cohort_id: @cohort).sort_by do |application|
      application.full_name
    end
  end

  def refresh
    GreenhouseHarvester.new(@cohort).run
    redirect_to cohort_applications_path(@cohort)
  end

  def import
    application = GreenhouseApplication.find(params[:id])
    user = application.create_user
    StudentMailer.invitation(user).deliver
    redirect_to cohort_applications_path(@cohort), notice: "#{user.full_name} was imported successfully"
  end

end
