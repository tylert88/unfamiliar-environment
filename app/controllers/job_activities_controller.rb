class JobActivitiesController < ApplicationController

  before_action except: :all do
    @user = User.find(params[:user_id])
    @cohort = @user.current_cohort
  end

  def all
    @job_activities = JobActivity.all
    authorize(JobActivity)
    respond_to do |format|
      format.html
      format.csv do
        csv = CSV.generate do |csv|
          csv << [
            "Student URL",
            "Student ID",
            "First Name",
            "Last Name",
            "Activity ID",
            "Company",
            "Position",
            "Status",
            "Date of last interaction",
            "Job source",
            "Url",
          ]
          @job_activities.each do |activity|
            csv << [
              user_url(activity.user),
              activity.user_id,
              activity.user.first_name,
              activity.user.last_name,
              activity.id,
              activity.company,
              activity.position,
              activity.status,
              activity.date_of_last_interaction,
              activity.job_source,
              activity.url,
            ]
          end
        end
        render text: csv
      end
    end
  end

  def index
    @job_activities = JobActivity.where(user_id: @user).order('date_of_last_interaction desc')
    authorize(JobActivity.new(user: @user))
  end

  def show
    redirect_to user_job_activities_path(@user)
  end

  def new
    @job_activity = JobActivity.new(user: @user)
    authorize(@job_activity)
  end

  def create
    @job_activity = JobActivity.new(job_activity_params.merge(user: @user))
    authorize(@job_activity)
    if @job_activity.save
      redirect_to user_job_activities_path(@user), notice: "Job Activity was created"
    else
      render :new
    end
  end

  def edit
    @job_activity = JobActivity.find(params[:id])
    authorize(@job_activity)
  end

  def update
    @job_activity = JobActivity.find(params[:id])
    authorize(@job_activity)
    if @job_activity.update(job_activity_params)
      redirect_to user_job_activities_path(@user), notice: "Job Activity was updated"
    else
      render :edit
    end
  end

  def destroy
    @job_activity = JobActivity.find_by_id(params[:id])
    authorize(@job_activity)
    @job_activity.try(:destroy)
    redirect_to user_job_activities_path(@user), notice: "Job Activity was deleted"
  end

  private def job_activity_params
    params.require(:job_activity).permit(
      :company,
      :position,
      :status,
      :date_of_last_interaction,
      :job_source,
      :url,
    )
  end

end
