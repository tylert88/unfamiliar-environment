class UsersController < ApplicationController

  after_action :verify_authorized

  def index
    @users = User.order(:first_name, :last_name)
    authorize(User)

    respond_to do |format|
      format.html
      format.csv do
        content_disposition = 'attachment; filename="all-students.csv"'
        response.headers['Content-Disposition'] = content_disposition
        render text: UserExporter.new(@users).to_csv(view_context)
      end
    end
  end

  def new
    @user = User.new
    authorize(@user)
  end

  def create
    @user = User.new(user_params)
    authorize(@user)

    if params[:enrollment] && params[:enrollment][:cohort_id].present?
      @user.enrollments.build(
        cohort_id: params[:enrollment][:cohort_id],
        role: :student,
        status: :enrolled,
      )
    end

    if @user.save
      if @user.user? && params[:send_welcome_email] == '1'
        StudentMailer.invitation(@user).deliver
      end
      redirect_to(
        user_path(@user, cohort_id: params[:cohort_id]),
        notice: 'User created successfully'
      )
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
    authorize(@user)
    @cohort ||= @user.current_cohort
  end

  def edit
    @user = User.find(params[:id])
    authorize(@user)
  end

  def update
    @user = User.find(params[:id])
    authorize(@user)

    if @user.update(user_params)
      if current_user.instructor?
        redirect_to(
          user_path(@user, cohort_id: params[:cohort_id]),
          notice: 'Profile updated successfully'
        )
      else
        redirect_to(
          edit_user_path(@user),
          notice: 'Profile updated successfully'
        )
      end
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(
      *policy(@user || User).permitted_attributes
    )
  end

end
