class CohortsController < ApplicationController

  after_action :verify_authorized

  def index
    @cohorts = Cohort.all
    authorize(Cohort)
  end

  def new
    @cohort = Cohort.new
    authorize(@cohort)
  end

  def create
    @cohort = Cohort.new(cohort_params)
    authorize(@cohort)

    if @cohort.save
      flash[:notice] = "Cohort created"
      redirect_to cohorts_path
    else
      render :new
    end
  end

  def edit
    @cohort = Cohort.find(params[:id])
    authorize(@cohort)
  end

  def update
    @cohort = Cohort.find(params[:id])
    authorize(@cohort)

    if @cohort.update(cohort_params)
      flash[:notice] = "Cohort saved"
      redirect_to cohort_path(@cohort)
    else
      render :edit
    end
  end

  def show
    @cohort = Cohort.find(params[:id])
    authorize(@cohort)
    @students = User.for_cohort(@cohort).sort_by { |user| user.full_name.downcase }

    respond_to do |format|
      format.html
      format.csv do
        content_disposition = 'attachment; filename="' + @cohort.name.gsub(/[^a-z0-9]+/i, "-") + '.csv"'
        response.headers['Content-Disposition'] = content_disposition
        render text: UserExporter.new(@students).to_csv(view_context)
      end
    end
  end

  def send_one_on_ones
    @cohort = Cohort.find(params[:id])
    authorize(@cohort)
    instructor_appointments = {}
    params[:appointments].values.each do |appointment|
      if appointment[:selected] == '1'
        student = User.find(appointment[:student_id])
        instructor_appointments[appointment[:instructor_id]] ||= []
        instructor_appointments[appointment[:instructor_id]] << OpenStruct.new(
          student: student,
          time: appointment[:time],
          date: appointment[:date].to_date,
        )
        StudentMailer.one_on_one(
          current_user,
          student,
          User.find(appointment[:instructor_id]),
          appointment[:time],
          appointment[:date].to_date,
        ).deliver
      end
    end
    instructor_appointments.each do |instructor_id, appointments|
      InstructorMailer.one_on_one_schedule(User.find(instructor_id), appointments).deliver
    end
    redirect_to(
      one_on_ones_cohort_path(params[:id]),
      notice: "Invitations were sent!"
    )
  end

  def one_on_ones
    @cohort = Cohort.find(params[:id])
    authorize(@cohort)
    @start_time = params[:start_time].presence || '1:00pm'
    @end_time = params[:end_time].presence || '4:45pm'
    @start_date = params[:start_date] ? params[:start_date].to_date : Date.current

    students = User.for_cohort(params[:id])
    @all_instructors = @cohort.instructors
    @selected_instructors = if params[:instructor_ids]
      @all_instructors.select { |instructor| params[:instructor_ids].include?(instructor.id.to_s) }
    else
      @all_instructors
    end
    scheduler = OneOnOneScheduler.new(
      students,
      instructors: @selected_instructors,
      start_time: @start_time,
      end_time: @end_time,
      start_date: @start_date,
    )
    scheduler.generate_schedule
    @appointments = scheduler.appointments
  end

  def acceptance
    @cohort = Cohort.find(params[:id])
    authorize(@cohort)
    @users = User.for_cohort(@cohort)
    @class_project = ClassProject.find(params[:class_project_id])
    @tracker_statuses = TrackerStatus.where(user_id: @users, class_project_id: params[:class_project_id]).index_by(&:user_id)
    @users = @users.sort_by{|user| @tracker_statuses[user.id].try(:delivered) || -1 }.reverse
    @projects = StudentProject.where(user_id: @users, class_project_id: params[:class_project_id]).index_by(&:user_id)
  end

  def refresh_acceptance
    @cohort = Cohort.find(params[:id])
    authorize(@cohort)
    PivotalTrackerHarvester.new(@cohort).harvest
    redirect_to acceptance_cohort_path(@cohort, class_project_id: params[:class_project_id])
  end

  def mentorships
    @cohort = Cohort.find(params[:id])
    authorize(@cohort)
    @users = User.for_cohort(@cohort)
    @mentorships = Mentorship.current.where(user_id: @users)
  end

  def social
    @cohort = Cohort.find(params[:id])
    authorize(@cohort)
    @users = User.for_cohort(@cohort)
  end

  private

  def cohort_params
    params.require(:cohort).permit(
      :name,
      :start_date,
      :end_date,
      :showcase,
      :curriculum_id,
      :show_employment_ribbon,
      :hero,
      :label,
      :prereqs,
      :daily_feedback_url,
      :weekly_feedback_url,
      :calendar_url,
      :campus_id,
      :greenhouse_job_id,
      :course_id,
      :announced,
      :showcase_position,
    )
  end
end
