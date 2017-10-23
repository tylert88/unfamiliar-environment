class StaffingsController < ApplicationController

  def index
    @staffings = @cohort.staffings.includes(:user)
    authorize Staffing
  end

  def new
    @staffing = @cohort.staffings.new
    authorize @staffing
  end

  def create
    staffing_params = params.require(:staffing).permit(
      :user_id,
      :status,
    )
    @staffing = @cohort.staffings.new(staffing_params)
    authorize @staffing

    if @staffing.save
      redirect_to(
        cohort_staffings_path(@cohort),
        notice: 'Staffing created successfully'
      )
    else
      render :new
    end
  end

  def add_as_owner
    staffing = Staffing.find(params[:id])
    authorize staffing
    PivotalTrackerOwnerAdder.new(params[:cohort_id], staffing.user.email).add
    flash[:notice] = "We tried!  Hope it worked..."
    redirect_to cohort_staffings_path(params[:cohort_id])
  end

  def edit
    @staffing = @cohort.staffings.find(params[:id])
    authorize @staffing
  end

  def update
    staffing_params = params.require(:staffing).permit(
      :status,
    )
    @staffing = @cohort.staffings.find(params[:id])
    authorize @staffing

    if @staffing.update(staffing_params)
      redirect_to(
        cohort_staffings_path(@cohort),
        notice: 'Staffing updated successfully'
      )
    else
      render :edit
    end
  end

  def destroy
    @staffing = @cohort.staffings.find_by(id: params[:id]).try(:destroy)
    authorize @staffing
    redirect_to(
      cohort_staffings_path,
      notice: "Staffing was deleted successfully"
    )
  end

end
