class EnrollmentsController < ApplicationController

  def index
    @enrollments = Enrollment.all
    authorize(Enrollment)
  end

  def new
    @enrollment = Enrollment.new
    authorize(@enrollment)
  end

  def create
    @enrollment = Enrollment.new(enrollment_params)
    authorize(@enrollment)
    if @enrollment.save
      redirect_to enrollments_path, notice: 'Enrollment was created'
    else
      render action: :new
    end
  end

  def edit
    @enrollment = Enrollment.find(params[:id])
    authorize(@enrollment)
  end

  def update
    @enrollment = Enrollment.find(params[:id])
    authorize(@enrollment)
    if @enrollment.update(enrollment_params)
      redirect_to enrollments_path, notice: 'Enrollment was updated'
    else
      render action: :edit
    end
  end

  def destroy
    @enrollment = Enrollment.find(params[:id])
    authorize(@enrollment)
    @enrollment.destroy
    redirect_to enrollments_path, notice: 'Enrollment was deleted'
  end

  private

  def enrollment_params
    params.require(:enrollment).permit(:cohort_id, :user_id, :role, :status)
  end

end
